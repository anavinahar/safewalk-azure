#!/bin/bash

ROOT_PASSWORD=$1

my_dir=`dirname $0`
$my_dir/set_root_password.sh $ROOT_PASSWORD

