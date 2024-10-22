#!/bin/sh

if [ "${USE_SSL:-false}" = "true" ]; then
    echo "Running in SSL mode"
    while :; do
        nginx -g 'daemon off;' &
        nginx_pid=$!
        inotifywait -e create,modify,delete -r /etc/letsencrypt/live
        kill -HUP $nginx_pid
    done
else
    echo "Running in non-SSL mode"
    nginx -g 'daemon off;'
fi