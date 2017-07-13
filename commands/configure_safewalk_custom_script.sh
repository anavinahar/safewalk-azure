#!/bin/bash

ROOT_PASS=$1

usermod --password $(echo $ROOT_PASS | openssl passwd -1 -stdin) root

