#!/usr/bin/env bash
distro=""
centos=$(cat /etc/*-release | grep "centos")
ubuntu=$(cat /etc/*-release | grep "ubuntu")
if [ ! -z "$centos" ]
then
    distro="centos"
fi
if [ ! -z "$ubuntu" ]
then
    distro="ubuntu"
fi

if [ $distro == "centos" ]
then
    sudo yum install git -y
    sudo yum install vim -y
fi
if [ $distro == "ubuntu" ]
then
    sudo apt-get update
    sudo apt-get install git -y
    sudo apt-get install vim -y
fi
mkdir $HOME/lx-pref
git clone https://github.com/HX-Rd/lx-pref.git $HOME/lx-pref
find $HOME/lx-pref/ -type f -iname "*.sh" -exec chmod +x {} \;
$HOME/lx-pref/setup.sh
rm -rf /$HOME/lx-pref
