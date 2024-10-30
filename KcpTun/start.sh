#!/bin/sh
nohup ./client_darwin_amd64 -c config.json &
nohup ./client_darwin_amd64 -c config2.json &
open /Applications/ShadowsocksX-NG.app
