#!/bin/bash

wget https://dlcdn.apache.org/nifi/1.27.0/nifi-toolkit-1.27.0-bin.zip

mv nifi-toolkit-1.27.0 nitk
sudo mv nitk /opt/

cd /opt/nitk/bin/
./tls-toolkit.sh standalone -n $1, $2, $3 -O .
