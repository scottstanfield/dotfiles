#!/bin/bash
trap 'limactl stop deb; limactl delete --force deb' EXIT INT TERM

echo "Run `lima shell deb` to connect"
limactl start --foreground --name=deb lima-debian-trixie.yaml &
wait
