#!/bin/sh

if [ -f /srv/www/nextcloud/config/config.php ]; then
    /usr/bin/php-cli -f /srv/www/nextcloud/cron.php
    hour="$(date +%H)"
    last_check="$(cat /srv/www/nextcloud/data/.last_update_check | grep '^[0-9]\+$' || echo 0)"
    since_last_check="$(expr "$(date +%s)" - "$last_check")"
    two_days="$(expr 3600 \* 24 \* 2)"
    if [ "$hour" -gt 2 ] && [ "$hour" -lt 5 ] && [ "$since_last_check" -gt "$two_days" ]; then
        cd /srv/www/nextcloud/
        date +%s > /srv/www/nextcloud/data/.last_update_check
        /usr/bin/php-cli --define apc.enable_cli=1 updater/updater.phar -n  || echo "$last_check" > /srv/www/nextcloud/data/.last_update_check
        /usr/bin/php-cli ./occ app:update --all || echo "$last_check" > /srv/www/nextcloud/data/.last_update_check
        /usr/bin/php-cli ./occ db:add-missing-indices || echo "$last_check" > /srv/www/nextcloud/data/.last_update_check
    fi
fi
