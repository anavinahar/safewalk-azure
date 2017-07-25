#!/bin/bash

ROOT_PASSWORD=$1
SAFEWALK_IP=$2

my_dir=`dirname $0`
sh $my_dir/set_root_password.sh $ROOT_PASSWORD
sh $my_dir/gateway_whitelist_safewalk_server.sh $SAFEWALK_IP

