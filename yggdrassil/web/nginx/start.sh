#!/usr/bin/env sh
sleep 1m
sh reload.sh &
nginx -g "daemon off;"
