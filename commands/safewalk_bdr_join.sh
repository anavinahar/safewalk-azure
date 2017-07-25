#!/bin/bash

pushd /home/safewalk/safewalk_server/sources
bin/bdr_accept_node $1
bin/bdr_accept_node $2
bin/bdr_join_node $1 $2
popd
