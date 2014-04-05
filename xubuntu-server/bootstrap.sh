#!/usr/bin/env bash

echo 'Step 1 - Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Step 2 - Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme xfce4-goodies xubuntu-wallpapers gksu
