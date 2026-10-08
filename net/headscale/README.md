# headscale

[Headscale](https://github.com/juanfont/headscale) is a self-hosted
implementation of the Tailscale control server. This directory builds two
packages:

| package | content |
|---|---|
| `headscale` | the server, procd init script, UCI configuration, example ACL file |
| `headscale-lighttpd` | dedicated lighttpd instance (TLS + reverse proxy), Let's Encrypt integration |

`headscale` alone listens only on `127.0.0.1` and is not reachable from the
network. It is meant to be published through a TLS-terminating reverse proxy,
which is what `headscale-lighttpd` provides.

## Usage

### Prerequisites

* A DNS name pointing to the public IP address of the router
  (e.g. `hs.example.com`). It must be a dedicated host name, headscale cannot
  be served from a sub-path.
* Public IPv4 address on the router (WAN ports 80 and 443 must really reach
  it, no CGNAT).
* The ports listed in [Ports](#ports) must be free on the router.

### Minimal setup

```sh
opkg install headscale headscale-lighttpd

uci set headscale.main.server_url='https://hs.example.com'
uci set headscale.main.enabled='1'
uci set headscale.lighttpd.wan_access='1'
# Let's Encrypt needs a contact e-mail (skip if /etc/config/acme has one)
uci set headscale.lighttpd.acme_email='admin@example.com'
uci commit headscale

/etc/init.d/headscale restart
```

Add `uci set headscale.lighttpd.acme_staging='1'` first if you want to test
with the Let's Encrypt staging environment (it issues untrusted certificates
and has relaxed rate limits).

Create a user and a pre-auth key on the router, then register a client:

```sh
headscale users create alice
headscale preauthkeys create --user 1 --expiration 1h   # check ID with: headscale users list

# on the client
tailscale up --login-server https://hs.example.com --authkey <key>
```

The `headscale` command talks to the server over a local unix socket
(`/var/run/headscale/headscale.sock`), so it works only on the router, as root.

### Configuration

Everything is in `/etc/config/headscale` (the file is commented). The init
script renders it to `/var/etc/headscale/config.yaml` on every start, so after
changing it run `/etc/init.d/headscale restart` (or `reload`; both restart).

`config headscale 'main'`

| option | default | description |
|---|---|---|
| `enabled` | `0` | start the service |
| `server_url` | `https://hs.example.com` | public URL, must be `https://` with a host name only |
| `listen_port` | `8080` | headscale listens on `127.0.0.1:<port>` |
| `data_dir` | *(empty)* | database and private keys. Empty: `/srv/headscale` if the storage plugin is active (`storage.srv.uuid` set and `/srv` mounted), otherwise `/etc/headscale` |
| `log_level` | `info` | |
| `metrics_listen` | *(empty)* | Prometheus and debug endpoint, e.g. `127.0.0.1:9090`; empty disables it. It has no authentication, so only loopback addresses are accepted (the service refuses to start otherwise) |
| `policy_path` | *(empty)* | ACL policy file (HuJSON); empty allows everything. See `/etc/headscale/acl.hujson` |
| `config_file` | *(unset)* | use your own headscale YAML; all generated configuration is skipped |

`config prefixes 'prefixes'`: `v4` (`100.64.0.0/10`), `v6`
(`fd7a:115c:a1e0::/48`), `allocation` (`sequential`|`random`). Headscale
supports only **one prefix per family**; an empty value disables the family
and at least one has to remain.

`config derp 'derp'`

| option | default | description |
|---|---|---|
| `enabled` | `0` | run the embedded DERP relay (opens UDP `stun_port` on WAN) |
| `stun_port` | `3478` | |
| `ipv4`, `ipv6` | *(empty)* | public addresses advertised to clients |
| `tailscale_map` | `0` | also hand clients the public DERP servers operated by Tailscale Inc. |

The embedded DERP relay is **not** published anywhere. It is only added to the
DERP map that this headscale sends to its own clients, and it only relays for
nodes of your tailnet (`verify_clients` is always on). With `tailscale_map` off
and DERP disabled, clients get no relay at all (the init script warns); direct
connections still work where NAT allows it.

`config lighttpd 'lighttpd'` (`headscale-lighttpd` only)

| option | default | description |
|---|---|---|
| `enabled` | `1` | run the dedicated lighttpd |
| `https_port` | `8443` | TLS port of the dedicated lighttpd |
| `http_port` | `8081` | plain HTTP port of the dedicated lighttpd |
| `wan_access` | `0` | forward WAN 443/80 to the ports above in the firewall |
| `acme` | `1` | manage a Let's Encrypt certificate for the `server_url` host |
| `acme_email` | *(empty)* | ACME account e-mail, only used if `/etc/config/acme` has none |
| `acme_staging` | `0` | use the Let's Encrypt staging environment |
| `remote_api` | `0` | let the internet reach the REST admin API (`/api/`), `/swagger` and `/version`; see [Security](#security) |

DNS / MagicDNS is not exposed; the generated configuration disables it. Use
`config_file` if you need it.

## Ports

These must not be used by anything else on the router:

| port | where | used for | required |
|---|---|---|---|
| 8080/tcp | `127.0.0.1` | headscale (`listen_port`) | always |
| 8443/tcp | all interfaces | dedicated lighttpd, TLS (`https_port`) | `headscale-lighttpd` |
| 8081/tcp | all interfaces | dedicated lighttpd, HTTP (`http_port`) | `headscale-lighttpd` |
| 3478/udp | all interfaces | embedded DERP STUN (`stun_port`) | `derp.enabled` |
| *metrics* | as configured | `metrics_listen` | only if set |

On the **WAN side**, public ports **443/tcp** and **80/tcp** must be available
for the redirects (`wan_access=1`). Do not combine them with your own
port forwardings or services on those public ports. Port 80 is needed even if
you only use HTTPS, because Let's Encrypt validates over it. The system
lighttpd (reForis, LuCI) keeps its ports 80/443 on the LAN as before and is
not modified in any way.

Ports 8443 and 8081 are bound on all interfaces, but the firewall only
forwards WAN traffic to them when `wan_access` is on. LAN clients can reach
them directly.

## How it works

### Service

`/etc/init.d/headscale` (procd, `START=95`) does the following on every start:

1. Synchronizes the firewall (even when disabled, so that ports get closed).
2. Validates `server_url` and the prefixes.
3. Creates the data directory (owner `headscale`, mode `0700`) and renders
   `/var/etc/headscale/config.yaml` (tmpfs, generated again every start). TLS is
   left empty in headscale because lighttpd terminates it; `127.0.0.1`/`::1` are
   trusted proxies so client addresses are taken from the forwarded headers.
4. Synchronizes the ACME certificate entry (see below).
5. Starts procd instances `headscale` (runs as user `headscale`) and, with
   `headscale-lighttpd`, `lighttpd`.

### Firewall

The firewall rules are ordinary named sections in `/etc/config/firewall`,
created and maintained by the init script (they therefore also show up in
LuCI and reForis):

| section | type | rule |
|---|---|---|
| `headscale_https` | redirect | WAN tcp 443 → router port `https_port` |
| `headscale_acme` | redirect | WAN tcp 80 → router port `http_port` |
| `headscale_stun` | rule | accept WAN udp `stun_port` |

`enabled` of each section is set from the headscale configuration (the
redirects need `main.enabled`, `lighttpd.enabled` and `lighttpd.wan_access`;
STUN needs `main.enabled` and `derp.enabled`). If anything changed, the init
script commits the firewall configuration and reloads the firewall **before**
starting any process. At boot the firewall (`START=19`) already loads the
committed sections long before headscale (`START=95`). Stopping the service
leaves the sections as they are; disable the service in UCI and restart it to
close the ports. Removing the packages deletes the sections.

Redirecting to dedicated high ports (instead of opening WAN 80/443 to the
system lighttpd) is what keeps the router's web interfaces off the internet.

Limitation: the redirects apply only to traffic arriving from WAN. A LAN
client that connects to the router's public address on 443 reaches the system
lighttpd (reForis/LuCI) instead of headscale, and gets a certificate for the
wrong name. If LAN machines need to register, add your own redirect from the
`lan` zone (port 443 → `https_port`, port 80 → `http_port`) to
`/etc/config/firewall`, or point the host name to the router at `https_port`
in a way that fits your network. This is not set up by the package.

### Dedicated lighttpd (`headscale-lighttpd`)

The system lighttpd cannot be used for this safely: lighttpd applies the
`$HTTP["url"]` rules of every file in `/etc/lighttpd/conf.d` (reForis, LuCI,
webapps, document root `/www`) to all of its sockets, so a "headscale-only"
socket would still serve them. Instead, a second lighttpd process is started
by procd with a self-contained generated configuration
(`/var/etc/headscale/lighttpd.conf`, produced by
`/usr/libexec/headscale/lighttpd-conf.sh`, validated with `lighttpd -tt`
before start). It never includes `/etc/lighttpd/conf.d`, loads only
`mod_access`, `mod_alias`, `mod_redirect`, `mod_proxy` and `mod_openssl`, and
its document root is `/var/empty`. Everything is denied by default and only
requests with `Host: <server_url host>` are allowed:

* **`http_port`** (WAN 80): `/.well-known/acme-challenge/<token>` is served
  from `/var/run/acme/challenge/`; any other URL is redirected (301) to
  `https://<host>/`.
* **`https_port`** (WAN 443): TLS 1.2+, HTTP/1.1 only (HTTP/2 is disabled
  because the Tailscale control protocol uses connection upgrade), everything
  is proxied to `127.0.0.1:<listen_port>` with `Upgrade` support and
  forwarded client address.
* Any other Host header (including a plain IP) gets 403 on both ports.

The certificate used is `/etc/ssl/acme/<host>.fullchain.crt` with
`/etc/ssl/acme/<host>.key` if they exist; otherwise a temporary self-signed
certificate generated into `/var/etc/headscale/selfsigned.pem`.
If the generated configuration is invalid the proxy is not started and an
error is logged, headscale itself keeps running.

### Let's Encrypt (ACME)

Certificates are issued by the OpenWrt `acme-acmesh` package (`acme.sh`);
headscale's built-in ACME client is not used. The flow:

1. On start the init script maintains a certificate section in
   `/etc/config/acme`:

   ```
   config cert 'headscale'
   	option enabled '1'                 # follows main.enabled && lighttpd.enabled && lighttpd.acme
   	option validation_method 'webroot'
   	option staging '0'                 # from lighttpd.acme_staging
   	list domains 'hs.example.com'      # host of server_url
   ```

   `account_email` in the global `acme` section is filled from
   `headscale.lighttpd.acme_email` only if it is empty. Let's Encrypt
   requires one, without it issuing fails (the init script logs a warning).
2. The challenge type is **HTTP-01 / webroot**: `acme.sh` writes a token file
   to `/var/run/acme/challenge/` and Let's Encrypt fetches
   `http://<host>/.well-known/acme-challenge/<token>` on **public port 80**. This
   is answered by the dedicated lighttpd through the `headscale_acme`
   redirect. So the host name must resolve to the router, WAN port 80 must be
   reachable and `wan_access` must be on. (DNS-01 and wildcard certificates
   are not set up by this package.)
3. When the `acme` section changed, the init script starts the `acme` service
   15 seconds later (so lighttpd is already listening). The certificate and
   key are stored in `/etc/ssl/acme/`.
4. Renewals are done by the `acme` package itself, on its own schedule (see
   `/etc/config/acme` and its cron job). After every issue or renewal, `acme` calls
   `/etc/hotplug.d/acme/50-headscale`, which restarts the headscale service
   so the dedicated lighttpd is regenerated and picks up the new
   certificate (this includes a short restart of headscale itself).
5. Until the first certificate arrives the self-signed one is served, so
   clients will refuse to connect during that time.

To follow the progress: `logread -e acme`, `ls /etc/ssl/acme/`,
`openssl s_client -connect hs.example.com:443 -servername hs.example.com`.

## Security

Who can administer the server:

* **The local `headscale` command** talks to a unix socket
  (`/var/run/headscale/headscale.sock`). The socket has no authentication; access
  is limited by file permissions to `root` and the `headscale` user
  (directory `0750`, socket `0770`).
* **The REST API** (`/api/v1/`) requires a Bearer API key. Keys can only be
  created locally (`headscale apikeys create`). It is **blocked in the public
  lighttpd by default** (403, together with `/swagger` and `/version`), since
  Tailscale clients do not use it. Set `headscale.lighttpd.remote_api='1'`
  to expose it; then protect and rotate the keys (`--expiration`).
* **The TCP gRPC listener is not started** (`grpc_allow_insecure` is false and
  no TLS is configured in headscale), so nothing listens on port 50443.
* The ACL policy can only be changed by editing the policy file
  (`policy.mode: file`); the API refuses to change it.
* The unauthenticated debug/metrics server is off by default and may only be
  bound to a loopback address.

What the internet can reach (`wan_access=1`) is only the headscale protocol
endpoints a client needs: `/key`, `/ts2021` (control protocol), `/register/…`,
`/verify`, `/health`, `/derp*` (with embedded DERP), `/apple`, `/windows` and
a few static pages. A new node still has to be approved by an administrator
(`headscale nodes register`) or present a pre-auth key (`headscale preauthkeys
create`). Treat pre-auth keys as passwords: prefer short expiry and
single use.

Headscale runs as the unprivileged user `headscale`; its configuration is
readable only by root and that user, and `data_dir` (database and private
keys) is `0700`.

## Notes

* Data (database, noise and DERP private keys) lives in `data_dir`. Back it
  up; losing the keys means all clients have to re-register.
* The `headscale` binary is large (tens of MB). Go is not available for all
  Turris targets (not built for 32-bit PowerPC).
* `server_url` cannot be changed without clients re-registering; choose the
  final host name before you add nodes.
