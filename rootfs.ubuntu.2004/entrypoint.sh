#!/usr/bin/env bash

# clean up
rm -rf /tmp/.X0-lock
rm -rf /tmp/.X11-unix
rm -rf /tmp/.ICE-unix

# start supervisor
exec /usr/bin/supervisord \
    --nodaemon \
    --configuration /etc/supervisor/supervisord.conf
