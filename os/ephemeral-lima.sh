#!/bin/bash
trap 'limactl stop deb; limactl delete --force deb' EXIT INT TERM

limactl start --foreground --name=deb lima-debian-trixie.yaml &
wait
