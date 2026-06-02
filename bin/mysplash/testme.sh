#!/usr/bin/env bash
#scutil --nwi | grep address
ipconfig getifaddr "$(route get 1.1.1.1 | awk '/interface:/{print $2}')"
#ifconfig -l | xargs -n1 ipconfig getifaddr
true
