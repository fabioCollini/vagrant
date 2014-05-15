#!/usr/bin/env bash

echo 'Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme \
xfce4-goodies xubuntu-wallpapers gksu cifs-utils xfce4-whiskermenu-plugin firefox \
xarchiver filezilla

echo 'Set italian timezone...'
echo "------------------------"
echo "Europe/Rome" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

echo 'Set italian keyboard layout...'
echo "------------------------"
sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="it"/g' /etc/default/keyboard

echo 'Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*; sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

echo 'Install JDK 7 in /usr/lib/jvm/java-7-oracle...'
echo "------------------------"
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-jdk7-installer

echo 'Install JDK 6 in /usr/lib/jvm/java-6-oracle...'
sudo apt-get install -y oracle-java6-installer

echo 'Create Development directory...'
echo "------------------------"
mkdir Development
sudo chmod 777 /home/vagrant/Development/

echo 'Install Eclipse JEE Kepler SR2...'
echo "------------------------"
wget http://eclipse.mirror.garr.it/mirrors/eclipse//technology/epp/downloads/release/kepler/SR2/eclipse-jee-kepler-SR2-linux-gtk-x86_64.tar.gz -P /tmp
tar xzf /tmp/eclipse-jee-*-linux-gtk*.tar.gz -C /home/vagrant/Development/
sudo ln -s /home/vagrant/Development/eclipse/eclipse /usr/bin/eclipse
wget -N https://raw.github.com/lfiammetta/vagrant/master/settings/xubuntu/eclipse.desktop -P /tmp
sudo mv /tmp/eclipse.desktop /usr/share/applications/
rm /tmp/eclipse-jee-*-linux-gtk*.tar.gz

echo 'Install Tomcat 7.0.39...'
echo "------------------------"
wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.39/bin/apache-tomcat-7.0.39.tar.gz -P /tmp
tar xzf /tmp/apache-tomcat*.tar.gz -C /home/vagrant/Development/
rm /tmp/apache-tomcat*.tar.gz

# http://localhost/
echo 'Install Apache2...'
echo "------------------------"
sudo apt-get install apache2 -y

echo 'Install PHP 5...'
echo "------------------------"
sudo apt-get install php5 -y

echo 'Install MySql...'
echo "------------------------"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install mysql-server

# http://localhost/phpmyadmin/
echo 'Install phpMyAdmin...'
echo "------------------------"
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install phpmyadmin

echo 'Install DBeaver 2.4.0...'
echo "------------------------"
wget -c http://dbeaver.jkiss.org/files/dbeaver_2.4.0_amd64.deb -P /tmp
sudo dpkg -i /tmp/dbeaver_2.4.0_amd64.deb
sudo apt-get install -f
rm /tmp/dbeaver*.deb

echo 'Install Git and create local repository directory'
echo "------------------------"
sudo apt-get install git -y
mkdir /home/vagrant/Development/git
sudo chmod 777 /home/vagrant/Development/git

echo 'Install Maven in /usr/share/maven...'
echo "------------------------"
sudo apt-cache search maven
sudo apt-get install maven -y

