#!/bin/bash
trap 'limactl stop deb; limactl delete --force deb' EXIT INT TERM

echo "Run this to connect: limactl shell deb"
limactl start --yes --foreground --name=deb ./lima-debian-trixie.yaml &
wait
