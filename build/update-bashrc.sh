#! /bin/bash

USER_ID=$(id -ru gpadmin)

cat >> /home/gpadmin/.bashrc << EOF
[ -z "${XDG_RUNTIME_DIR}" ] && export XDG_RUNTIME_DIR=/run/user/$USER_ID
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
EOF
