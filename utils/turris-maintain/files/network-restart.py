#!/usr/bin/python3

import time
import json
import re
import subprocess
from typing import NoReturn
import euci

from foris_controller.buses.mqtt import MqttNotificationSender


class BaseClass:
    TIME = 2000
    STEP = 200
    NOTIFY_EVENT = None  # redefine it in child classes

    def __init__(self):
        self.uci = euci.EUci()
        try:
            self.controller_id = subprocess.check_output(
                ["crypto-wrapper", "serial-number"]).decode().strip()
        except subprocess.CalledProcessError:
            self.controller_id = None

        self._get_mqtt_config_vars()
        self.sender = MqttNotificationSender(self.host, self.port, self.credentials)

    def _get_mqtt_config_vars(self):
        self.host = self.uci.get("foris-controller", "mqtt", "host", default="localhost")
        self.port = self.uci.get("foris-controller", "mqtt", "port", dtype=int, default=11883)
        self.passwd_path = self.uci.get(
            "foris-controller", "mqtt", "credentials_file", default="/etc/fosquitto/credentials.plain"
        )
        with open(self.passwd_path, "r") as f:
            self.credentials = re.match(r"^([^:]+):(.*)$", f.readlines()[0][:-1]).groups()

    def _notify_progress(self, msg=None):
        remains = self.TIME
        notification_msg = {"remains": remains}
        if msg:
            notification_msg.update(msg)

        while remains > 0:
            self.sender.notify(
                "maintain", self.NOTIFY_EVENT, notification_msg,
                controller_id=self.controller_id,
            )
            time.sleep(float(self.STEP) / 1000)
            remains -= self.STEP

        # how to handle the final {"remains": 0}
        self.sender.notify(
            "maintain", self.NOTIFY_EVENT, notification_msg, controller_id=self.controller_id,
        )

    def _run_final_action(self) -> NoReturn:
        """Run action (e.g. service reload) after sending notification."""
        raise NotImplementedError

    def run(self) -> NoReturn:
        """Define all steps that needs to be run for maintain-<something>."""
        raise NotImplementedError


class NetworkClass(BaseClass):
    def __init__(self):
        self.ips = []
        super().__init__()

    def _get_router_ips(self):
        # try to detect ips from uci
        # parse ips as if they were in CIDR notation
        self.ips += [e.split("/")[0] for e in self.uci.get("network", "lan", "ipaddr", list=True, default=()) if e]
        self.ips += [e.split("/")[0] for e in self.uci.get("network", "lan", "ip6addr", list=True, default=()) if e]
        self.ips += [e.split("/")[0] for e in self.uci.get("network", "wan", "ipaddr", list=True, default=()) if e]
        self.ips += [e.split("/")[0] for e in self.uci.get("network", "wan", "ip6addr", list=True, default=()) if e]

        # try to detect_ips from ubus
        for network in ["lan", "wan"]:
            try:
                output = subprocess.check_output(["ifstatus", network])
                data = json.loads(output)
                self.ips += [e["address"] for e in data.get("ipv4-address", [])]
                self.ips += [e["address"] for e in data.get("ipv6-address", [])]
            except (subprocess.CalledProcessError, ):
                pass

# in the actual maintain-something module
class NetworkRestart(NetworkClass):
    TIME = 3000
    STEP = 200
    NOTIFY_EVENT = "network-restart"
    SERVICE_NAME = "network"

    def _run_final_action(self):
        subprocess.call([f"/etc/init.d/{self.SERVICE_NAME}", "reload"])

    def run(self):
        self._get_router_ips()
        self._notify_progress()
        self._run_final_action()


network_restart = NetworkRestart()
network_restart.run()
