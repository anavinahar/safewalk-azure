#!/bin/bash

ROOT_PASSWORD=$1
GATEWAY_IP=$2
GATEWAY_PUBLIC_IP=$3
GATEWAY_ROOT_PASSWORD=$4
SAFEWALK_IP_1=$5
SAFEWALK_IP_2=$6

#sh configure_safewalk_custom_script.sh root 192.168.10.244 192.168.10.244 Safewalk1 192.168.10.201 192.168.10.202

my_dir=`dirname $0`

bash $my_dir/safewalk_make_partitions.sh

sh $my_dir/set_root_password.sh $ROOT_PASSWORD

sh $my_dir/safewalk_renew_secrets.sh

#bash $my_dir/safewalk_create_gateway.sh --gateway-name "My Gateway" --gateway-password $GATEWAY_ROOT_PASSWORD --gateway-public-host $GATEWAY_PUBLIC_IP --gateway-ssh-host $GATEWAY_IP --safewalk-host $SAFEWALK_IP_1

cp $my_dir/bdr_join_node /home/safewalk/safewalk_server/sources/bin/bdr_join_node
chmod +x /home/safewalk/safewalk_server/sources/bin/bdr_join_node
chown safewalk:safewalk /home/safewalk/safewalk_server/sources/bin/bdr_join_node
bash safewalk_bdr_join.sh $SAFEWALK_IP_2 $SAFEWALK_IP_1
