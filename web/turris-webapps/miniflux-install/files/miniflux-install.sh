#!/bin/sh
set -eu
mkdir -p /srv/postgresql
chown postgres:postgres /srv/postgresql
/etc/init.d/postgresql start

user=miniflux
dbname=miniflux

createuser -U postgres $user
createdb -U postgres -O $user $dbname
psql -U postgres $dbname -c 'create extension hstore'
psql -U postgres -c "ALTER USER $user WITH SUPERUSER;"
DATABASE_URL="user='$user' dbname='$dbname' sslmode=disable" miniflux.app -migrate
psql -U postgres -c "ALTER USER $user WITH NOSUPERUSER;"

echo Creating miniflux user
while :; do
	fail=
	DATABASE_URL="user='$user' dbname='$dbname' sslmode=disable" miniflux.app -create-admin || fail=y
	if ! [ "$fail" ]; then
		break;
	fi
done

sed -i "s/option user .*/option user $user/" /etc/config/miniflux
sed -i "s/option dbname .*/option dbname $dbname/" /etc/config/miniflux
/etc/init.d/miniflux start
