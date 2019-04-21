#!/bin/bash
set -o errexit

## TODO
# where to store keys?
# how to log node errors?
# how to keep node going?
# install tmux for pair programming
# minimal tmux, vimrc and bash
# is this the best distro?


## Set the time (DEBIAN)
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

## update the box
sudo apt update && sudo apt-get dist-upgrade -y
sudo apt upgrade

# install GCC compiler
sudo apt install -y build-essential libssl-dev automake

## install essential utilities
sudo apt install -y git zsh neovim pigz pydf glances htop tree neofetch jq  unzip httpie

## create accounts and groups
addgroup --gid 1050 usc
usermod -a -G usc $(whoami)
adduser --uid 1010 --gecos "" --ingroup usc --disabled-password scott
adduser --uid 1011 --gecos "" --ingroup usc --disabled-password ryan
usermod -a -G sudo scott
usermod -a -G sudo ryan
passwd scott

## change to zsh
sudo chsh -s /usr/bin/zsh $(whoami)

## clone dmz repo
sudo chsh -s /usr/bin/zsh ubuntu
cd
git clone https://github.com/scottstanfield/dmz.git
cd dmz

# do the rest by hand
echo "cd ~/dmz && ./install.sh"
./install.sh				# <-- this prompts to continue


## setup postgres
sudo apt install -y postgresql-client

## setup node
sudo apt install -yq ca-certificates

curl -sL https://deb.nodesource.com/setup_11.x | sudo bash -
sudo apt install -y nodejs 

## setup nginx
sudo apt-get install nginx

## setup SSL
# add backport BS: https://backports.debian.org/Instructions/
cat > /etc/apt/sources.list.d/backports.list << EOF
sudo deb http://deb.debian.org/debian stretch-backports main
EOF
sudo apt-get install certbot python-certbot-nginx -t stretch-backports

## install docker (jesus christ)
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

## or
curl -sSL https://get.docker.com | sudo bash -


## install github public key
curl -s https://github.com/scottstanfield.keys | grep ed25519  >> ~/.ssh/authorized_keys
curl -s https://github.com/ryanloney.keys      | grep ed25519  >> ~/.ssh/authorized_keys

## install R
sudo apt-get install -y libcurl4-openssl-dev # for R packages
cd ~
mkdir tmp
cd tmp
wget https://mran.blob.core.windows.net/install/mro/3.5.1/microsoft-r-open-3.5.1.tar.gz
tar xf mi[TAB]
cd mic[TAB]
sudo ./install.sh --accept-mkl-eula --unattended


## Additional utilities in rust
## dust: a faster du (disk usage)
## ripgrep [rg]: faster grep/search
## xsv: fast CSV manipulation
## hyperfine: timer: see header of ~/.zshrc

cd 
curl https://sh.rustup.rs -sSf | sh
source ~/.zshrc
rustc -V
cargo install ripgrep scrubcsv du-dust xsv rust-gist hyperfine


##
## Anaconda Python setup for Intel MKL 
##

## setup intel channel
## https://www.infoworld.com/article/3187484/software/how-does-a-20x-speed-up-in-python-grab-you.html
cd ~
mkdir -p tmp && cd tmp
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b					# install in batch mode

### log out, come back
source ~/miniconda3/etc/profile.d/conda.sh activate
conda config --add channels intel
conda create --name intelpy intelpython3_full python=3
conda env list
conda activate intelpy		# this takes awhile
pip install --upgrade pip

##
## Clone main repo
##

git clone git@github.com:campfireai/cf.git
cd cf/5.aws
python transcendentals.py # should be ~ 1 second for Intel Skylake with AVX-512


