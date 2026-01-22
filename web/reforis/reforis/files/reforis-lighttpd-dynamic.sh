!/bin/sh

. /lib/functions.sh

config_load reforis
config_get SCRIPTNAME server scriptname "/reforis"

# scriptname must not contain escape codes (avoid CRLF injection in sed later)
# and for the sake of UX, trailing and leading slashes are trimmed
SCRIPTNAME=$(echo "$SCRIPTNAME" | sed -e 's;\\;\\\\;g' | sed -e 's;/*$;;g' | sed -e 's;^/*;;g' | sed -e 's;/+;/;g')
[ "$SCRIPTNAME" != "" ] && SCRIPTNAME="/$SCRIPTNAME"

# get bus config
CONTROLLER_ID=$(crypto-wrapper serial-number)

REFORIS_PATH=$(python -c 'from pathlib import Path;print(Path(__import__("reforis").__file__).parent.parent)')

echo "var.reforis.bin = \"/usr/bin/reforis\""
echo "var.reforis.scriptname = \"$SCRIPTNAME\""

echo
echo "\$HTTP[\"url\"] =~ \"^\" + var.reforis.scriptname + \"/\" {"
echo " \$HTTP[\"url\"] =~ \"^\" + var.reforis.scriptname + \"/static/\" {"
echo "  alias.url += ( var.reforis.scriptname + \"/static/\" => \"${REFORIS_PATH}/reforis_static/\" )"
echo " } else {"
echo "  server.max-read-idle = 90"
echo '  fastcgi.debug = 0'
echo '  fastcgi.server = ( "/" => ( turris_auth_scriptname => turris_auth ))'
echo '  proxy.server = ( "" => ( ( "host" => "/var/run/reforis.sock" ) ) )'
echo " }"
echo "}"
