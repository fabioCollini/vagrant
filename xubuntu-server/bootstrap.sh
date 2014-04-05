#!/usr/bin/env bash

echo 'Step 1 - Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Step 2 - Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme xfce4-goodies xubuntu-wallpapers gksu

echo 'Step 3 - Install JDK 7 in /usr/lib/jvm/java-7-oracle...'
echo "------------------------"
add-apt-repository ppa:webupd8team/java
apt-get update -y
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get install -y oracle-jdk7-installer

echo 'Step 4 - Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*; sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

# http://localhost:9080
# Jenkins plugin mirror: http://mirrors.jenkins-ci.org/plugins/
echo 'Step 5 - Install Jenkins CI in /var/lib/jenkins/ and Git Plugin...'
echo "------------------------"
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=9080/g' /etc/default/jenkins
sudo wget http://mirrors.jenkins-ci.org/plugins/git-client/latest/git-client.hpi -P /var/lib/jenkins/plugins/
sudo wget http://mirrors.jenkins-ci.org/plugins/scm-api/latest/scm-api.hpi -P /var/lib/jenkins/plugins/
sudo wget http://mirrors.jenkins-ci.org/plugins/git/latest/git.hpi -P /var/lib/jenkins/plugins/
sudo wget -N https://raw.github.com/lfiammetta/vagrant/master/jenkins/config.xml -P /var/lib/jenkins/
sudo wget -N https://raw.github.com/lfiammetta/vagrant/master/jenkins/hudson.plugins.git.GitTool.xml -P /var/lib/jenkins/
sudo wget -N https://raw.github.com/lfiammetta/vagrant/master/jenkins/hudson.tasks.Maven.xml -P /var/lib/jenkins/
sudo /etc/init.d/jenkins restart


# http://localhost:9000
echo 'Step 6 - Install SonarQube in /opt/sonar...'
echo "------------------------"
sudo sh -c 'echo deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/ > /etc/apt/sources.list.d/sonar.list'
sudo apt-get update -y
sudo apt-get install sonar -y --force-yes
sudo sed -i 's/sonar.jdbc.url=jdbc:h2:tcp:\/\/localhost:9092\/sonar/#sonar.jdbc.url=jdbc:h2:tcp:\/\/localhost:9092\/sonar/g' /opt/sonar/conf/sonar.properties
sudo sed -i 's/#sonar.jdbc.url=jdbc:mysql:\/\/localhost:3306\/sonar/sonar.jdbc.url=jdbc:mysql:\/\/localhost:3306\/sonar/g' /opt/sonar/conf/sonar.properties
sudo sed -i 's/sonar.jdbc.username=sonar/sonar.jdbc.username=sonar/g' /opt/sonar/conf/sonar.properties
sudo sed -i 's/sonar.jdbc.password=sonar/sonar.jdbc.password=sonar/g' /opt/sonar/conf/sonar.properties
sudo service sonar start
sudo ln -s /opt/sonar/bin/linux-x86-32/sonar.sh /usr/bin/sonar
sudo chmod 755 /etc/init.d/sonar
sudo update-rc.d sonar defaults


# http://localhost:8081/nexus
echo 'Step 7 - Install Nexus Sonatype...'
echo "------------------------"
cd /usr/local
sudo mkdir nexus
cd nexus/
sudo wget http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz
sudo tar -xvzf nexus-latest-bundle.tar.gz
sudo rm nexus-latest-bundle.tar.gz
sudo mv nexus-* nexus-last
sudo sed -i 's/NEXUS_HOME=".."/NEXUS_HOME="\/usr\/local\/nexus\/nexus-last"/g' /usr/local/nexus/nexus-last/bin/nexus
sudo sed -i 's/#RUN_AS_USER=/RUN_AS_USER=root/g' /usr/local/nexus/nexus-last/bin/nexus
sudo sed -i 's/wrapper.java.command=java/wrapper.java.command=\/usr\/lib\/jvm\/java-7-oracle\/bin\/java/g' /usr/local/nexus/nexus-last/bin/jsw/conf/wrapper.conf
cd /etc/init.d
sudo ln -s /usr/local/nexus/nexus-last/bin/nexus /etc/init.d/nexus
sudo chmod 755 /etc/init.d/nexus
sudo update-rc.d nexus defaults
sudo service nexus start

# Directory della repository che crea Jenkins al primo lancio di un job: /var/lib/jenkins/.m2/repository
echo 'Step 8 - Install Maven in /usr/share/maven...'
echo "------------------------"
sudo apt-cache search maven
sudo apt-get install maven -y
mkdir -p /home/vagrant/.m2
wget -N https://raw.github.com/lfiammetta/vagrant/master/maven/settings.xml -P /home/vagrant/.m2

echo 'Step 9 - Install Git in /usr/bin/git...'
echo "------------------------"
sudo apt-get install git -y

# http://localhost/
echo 'Step 10 - Install Apache2...'
echo "------------------------"
apt-get install apache2 -y

echo 'Step 11 - Install PHP 5...'
echo "------------------------"
apt-get install php5 -y

echo 'Step 12 - Install MySql...'
echo "------------------------"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install mysql-server

# http://localhost/phpmyadmin/
echo 'Step 12 - Install phpMyAdmin...'
echo "------------------------"
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password vagrant'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password vagrant'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password vagrant'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'﻿
export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install phpmyadmin

echo 'Step 13 - Generate Sonar database...'
echo "------------------------"
sudo wget -N https://raw.github.com/lfiammetta/vagrant/master/mysql/sonar.sql -P /tmp/
sudo mysql -u root --password=vagrant < /tmp/sonar.sql

