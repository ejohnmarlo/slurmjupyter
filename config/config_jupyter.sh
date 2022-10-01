#!/bin/bash

#Set password
echo "c.ServerApp.password='$(python3 -c "from notebook.auth import passwd; print(passwd('$1'))")'"
