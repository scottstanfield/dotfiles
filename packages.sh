#!/usr/local/env bash
# vim:filetype=sh:

set -euo pipefail   # unofficial bash strict mode
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Tell apt-get we can't give feedback
export DEBIAN_FRONTEND=noninteractive

# consider:: nano htop xeyes git dos2unix gfortran
packages=(
    fd-find
    ripgrep
    fzf
    jq
    httpie
    wget
    neovim
    zsh
)

exit -1 # not finished yet

is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
is_osx() { [[ $SHELL_PLATFORM == 'osx' ]]; }

apt-get update
apt-get upgrade -y
apt-get install --no-install-recommends -y ${packages[*]}

# Install pip dependencies
python3 -m pip install \
    numpy==1.16.2 \
    picamera==1.13 \
    pyrr==0.10.3 \
    requests==2.21.0 \
    pytest==5.4.1 \
    dacite==1.5.0 \
    opencv-contrib-python==4.1.0.25

