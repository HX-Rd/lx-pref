#!/usr/bin/env bash
echo "Setting up environment"
echo "Checking distro version"
distro=""
centos=$(cat /etc/*-release | grep "centos")
if [ ! -z "$centos" ]
then
    distro="centos"
fi
chmod -R +x ./scripts
sudo ./scripts/$distro/install-support-packages.sh
mkdir $HOME/lx-pref
git clone https://github.com/HX-Rd/lx-pref.git $HOME/lx-pref
files=$(\ls -a .)
backup_folder=$HOME/env-backup
mkdir $HOME/env-backup
blacklist=(
    '.'
    '..'
    '.git'
    'setup.sh'
    'scripts'
)
for file in $files
do
    if [ -f $HOME/$file ] || [ -d $HOME/$file ]
    then
        if [[ ! " ${blacklist[@]} " =~ " ${file} " ]]
        then
            mv $HOME/$file $backup_folder/$file
        fi
    fi
    if [[ ! " ${blacklist[@]} " =~ " ${file} " ]]
    then
        mv ./$file $HOME/$file
    fi

done
echo "Done setting up environment"