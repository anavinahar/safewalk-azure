#!/bin/bash

ROOT_PASSWORD=$1

my_dir=`dirname $0`
sh $my_dir/set_root_password.sh $ROOT_PASSWORD

