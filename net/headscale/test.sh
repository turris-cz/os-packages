#!/bin/sh
# Runtime test, run by CI in OpenWrt container: test.sh PKG_NAME PKG_VERSION
. "$CI_HELPER"

case "$1" in
	headscale)
		headscale version || err_die "headscale does not run"

		cat > /tmp/headscale-test.yaml <<EOF
server_url: "https://hs.example.com"
listen_addr: "127.0.0.1:8080"
noise:
  private_key_path: /tmp/headscale-noise.key
prefixes:
  v4: "100.64.0.0/10"
derp:
  server:
    enabled: false
  urls: []
database:
  type: sqlite
  sqlite:
    path: /tmp/headscale.sqlite
dns:
  magic_dns: false
  base_domain: "tailnet.invalid"
  nameservers:
    global: []
unix_socket: /tmp/headscale.sock
EOF
		headscale configtest -c /tmp/headscale-test.yaml || err_die "configtest failed"
		sh -n /etc/init.d/headscale || err_die "init script has syntax error"
		success "headscale OK"
		;;
	headscale-lighttpd)
		/usr/libexec/headscale/lighttpd-conf.sh > /tmp/headscale-lighttpd.conf \
			|| err_die "failed to generate lighttpd configuration"
		lighttpd -tt -f /tmp/headscale-lighttpd.conf || err_die "invalid lighttpd configuration"
		success "headscale-lighttpd OK"
		;;
esac
