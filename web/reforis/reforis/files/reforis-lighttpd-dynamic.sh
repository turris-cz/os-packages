#!/bin/sh

. /lib/functions.sh

config_load reforis
config_get SCRIPTNAME server scriptname "/reforis"
config_get PORT server port "9090"

# scriptname must not contain escape codes (avoid CRLF injection in sed later)
# and for the sake of UX, trailing and leading slashes are trimmed
SCRIPTNAME=$(echo "$SCRIPTNAME" | sed -e 's;\\;\\\\;g' | sed -e 's;/*$;;g' | sed -e 's;^/*;;g' | sed -e 's;/+;/;g')
[ "$SCRIPTNAME" != "" ] && SCRIPTNAME="/$SCRIPTNAME"

echo "var.reforis.scriptname = \"$SCRIPTNAME\""

echo "\$HTTP[\"url\"] =~ \"^\" + var.reforis.scriptname + \"/\" {"
echo " \$HTTP[\"url\"] =~ \"^\" + var.reforis.scriptname + \"/static/\" {"
echo "  alias.url += ( var.reforis.scriptname + \"/static/\" => \"/usr/lib/pythonX.X/site-packages/reforis_static/\" )"
echo " } else {"
echo '   fastcgi.server = ( "/" => ( turris_auth_scriptname => turris_auth ))'
echo "   proxy.server = ( \"\" => ( ( \"host\" => \"127.0.0.1\", \"port\" => \"${PORT}\" ) ) )"
echo '   proxy.header = ( "upgrade" => "enable" )'
echo ' }'
echo '}'
