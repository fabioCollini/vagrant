#!/usr/bin/env bash

echo 'Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad \
xubuntu-icon-theme xfce4-goodies xubuntu-wallpapers gksu firefox cifs-utils \
xfce4-whiskermenu-plugin language-pack-it xarchiver filezilla

echo 'Set italian locale...'
sudo update-locale LANG="it_IT.UTF-8" LANGUAGE="it_IT"
sudo dpkg-reconfigure locales

echo 'Set italian timezone...'
echo "------------------------"
echo "Europe/Rome" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

echo 'Install JDK 6 in /usr/lib/jvm/java-6-oracle...'
echo "------------------------"
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java6-installer

echo 'Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*; sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

echo 'Create Development directory...'
echo "------------------------"
mkdir Development

echo 'Install Eclipse JEE Kepler...'
echo "------------------------"
wget http://mirror.netcologne.de/eclipse/technology/epp/downloads/release/kepler/R/eclipse-jee-kepler-R-linux-gtk.tar.gz -P /tmp
tar xzf /tmp/eclipse-jee-*-linux-gtk*.tar.gz -C /home/vagrant/Development/
sudo ln -s /home/vagrant/Development/eclipse/eclipse /usr/bin/eclipse
ln -s /home/vagrant/Development/eclipse/eclipse /home/vagrant/Desktop/eclipse
wget -N https://raw.github.com/lfiammetta/vagrant/master/settings/xubuntu/eclipse.desktop -P /tmp
sudo mv /tmp/eclipse.desktop /usr/share/applications/
rm /tmp/eclipse-jee-*-linux-gtk*.tar.gz

echo 'Install JBoss Tools...'
echo "------------------------"
wget http://sourceforge.net/projects/jboss/files/JBossTools/JBossTools4.1.x/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip -P /tmp
wget -N https://raw.github.com/lfiammetta/vagrant/master/settings/eclipse/install.xml -P /tmp
/home/vagrant/Development/eclipse/eclipse -consolelog -nosplash -data /tmp -application org.eclipse.ant.core.antRunner -f \
/tmp/install.xml \
-DsourceZip=/tmp/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip \
-DotherRepos=http://download.jboss.org/jbosstools/updates/stable/kepler/central/core/ \
-DtargetDir=/home/vagrant/Development/eclipse/
rm /tmp/install.xml
rm /tmp/jbosstools*.zip

echo 'Install Subversive and connectors...'
echo "------------------------"
wget http://mirror.netcologne.de/eclipse/technology/subversive/1.1/builds/kepler/Subversive-1.1.3.I20140206-1700.zip -P /tmp
unzip /tmp/Subversive-1.1.3.I20140206-1700.zip -d /tmp/Subversive
mv /tmp/Subversive/plugins/* /home/vagrant/Development/eclipse/plugins/
wget http://community.polarion.com/projects/subversive/download/eclipse/3.0/builds/Subversive-connectors-3.0.5.I20140122-1700.zip -P /tmp
unzip /tmp/Subversive-connectors-3.0.5.I20140122-1700.zip -d /tmp/Connectors
mv /tmp/Connectors/plugins/* /home/vagrant/Development/eclipse/plugins/
rm /tmp/Subversive* -R
rm /tmp/Connectors* -R

echo 'Install JBoss 7.1.1.Final...'
echo "------------------------"
wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz -P /tmp
tar zxf /tmp/jboss-as-7.1.1.Final.tar.gz -C /home/vagrant/Development
rm /tmp/jboss*.gz

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
sudo sed -i '$a lower_case_table_names  = 1' /etc/mysql/my.cnf
sudo service mysql restart

# http://localhost/phpmyadmin/
echo 'Install phpMyAdmin...'
echo "------------------------"
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install phpmyadmin
