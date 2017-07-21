#!/bin/bash

source /home/safewalk/safewalk-server-venv/bin/activate

django-admin.py create_gateway "$@" --settings=gaia_server.settings

deactivate
