#!/usr/bin/env bash
distro=""
centos=$(cat /etc/*-release | grep "centos")
if [ ! -z "$centos" ]
then
    distro="centos"
fi

if [ $distro == "centos" ]
then
    sudo yum install git -y
fi
mkdir $HOME/lx-pref
git clone https://github.com/HX-Rd/lx-pref.git $HOME/lx-pref
find $HOME/lx-pref/ -type f -iname "*.sh" -exec chmod +x {} \;
$HOME/lx-pref/setup.sh
rm -rf /$HOME/lx-pref
