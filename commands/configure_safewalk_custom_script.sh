#!/bin/bash

ROOT_PASS=$1
my_dir=`dirname $0`                
$my_dir/usermod --password $(echo $ROOT_PASS | openssl passwd -1 -stdin) root

