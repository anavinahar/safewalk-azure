#!/bin/sh

bash /home/safewalk/safewalk_server/sources/bin/update_fs_secrets_from_db
service apache2 restart
service postgresql restart
service supervisor restart
service gaiaradiusd stop
sleep 15
service gaiaradiusd start
