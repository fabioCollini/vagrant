#!/usr/bin/env bash

echo 'Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme \
xfce4-goodies xubuntu-wallpapers gksu firefox cifs-utils xfce4-whiskermenu-plugin \
language-pack-it xarchiver filezilla

echo 'Set italian locale...'
sudo update-locale LANG="it_IT.UTF-8" LANGUAGE="it_IT"
sudo dpkg-reconfigure locales

echo 'Set italian timezone...'
echo "------------------------"
echo "Europe/Rome" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

echo 'Install JDK 7 in /usr/lib/jvm/java-7-oracle...'
echo "------------------------"
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-jdk7-installer

echo 'Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*; sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

echo 'Create development directory...'
echo "------------------------"
mkdir /home/vagrant/Development

# open shell and write 'eclipse' to launch it
echo 'Install ADT Bundle 22...'
echo "------------------------"
wget http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86-20140321.zip -P /tmp
unzip /tmp/adt-bundle-linux-x86-20140321.zip -d /home/vagrant/Development/
sudo ln -s /home/vagrant/Development/adt-bundle-linux-x86-20140321/eclipse/eclipse /usr/bin/eclipse

