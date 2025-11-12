#!/bin/bash
dbus-update-activation-environment --systemd --all
kwalletd6 &
sleep 1 && kwallet-query >/dev/null 2>&1 &
EOF
