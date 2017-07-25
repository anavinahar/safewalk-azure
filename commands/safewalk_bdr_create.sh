#!/bin/bash

pushd /home/safewalk/safewalk_server/sources
bin/bdr_accept_node $1
bin/bdr_accepr_node $2
bin/bdr_create_group $1
popd
