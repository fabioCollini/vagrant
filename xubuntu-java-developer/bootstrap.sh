#!/usr/bin/env bash

echo 'Step 1 - Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Step 2 - Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme xfce4-goodies xubuntu-wallpapers gksu firefox

echo 'Step 3 - Install JDK 6 in /usr/lib/jvm/java-6-oracle...'
echo "------------------------"
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java6-installer

echo 'Step 4 - Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*; sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

echo 'Step 5 - Install Eclipse Kepler...'
echo "------------------------"
wget http://mirror.netcologne.de/eclipse/technology/epp/downloads/release/kepler/R/eclipse-jee-kepler-R-linux-gtk.tar.gz -P /tmp
sudo tar xzf /tmp/eclipse-jee-*-linux-gtk*.tar.gz -C /opt/
sudo ln -s /opt/eclipse/eclipse /usr/bin/eclipse
rm /tmp/eclipse-jee-*-linux-gtk*.tar.gz

echo 'Step 6 - Install JBoss Tools...'
echo "------------------------"
wget http://sourceforge.net/projects/jboss/files/JBossTools/JBossTools4.1.x/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip -P /tmp
wget -N https://raw.github.com/lfiammetta/vagrant/master/settings/eclipse/install.xml -P /tmp
sudo /opt/eclipse/eclipse -consolelog -nosplash -data /tmp -application org.eclipse.ant.core.antRunner -f \
/tmp/install.xml \
-DsourceZip=/tmp/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip \
-DotherRepos=http://download.jboss.org/jbosstools/updates/stable/kepler/central/core/ \
-DtargetDir=/opt/eclipse/
rm /tmp/install.xml
rm /tmp/jbosstools*.zip

echo 'Step 7 - Install Subversive and connectors...'
echo "------------------------"
wget http://mirror.netcologne.de/eclipse/technology/subversive/1.1/builds/kepler/Subversive-1.1.3.I20140206-1700.zip -P /tmp
unzip /tmp/Subversive-1.1.3.I20140206-1700.zip -d /tmp/Subversive
sudo mv /tmp/Subversive/plugins/* /opt/eclipse/plugins/
wget http://community.polarion.com/projects/subversive/download/eclipse/3.0/builds/Subversive-connectors-3.0.5.I20140122-1700.zip -P /tmp
unzip /tmp/Subversive-connectors-3.0.5.I20140122-1700.zip -d /tmp/Connectors
sudo mv /tmp/Connectors/plugins/* /opt/eclipse/plugins/
rm /tmp/Subversive* -R
rm /tmp/Connectors* -R

echo 'Step 8 - Install JBoss 7.1.1.Final...'
echo "------------------------"
wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz -P /tmp
sudo tar zxf /tmp/jboss-as-7.1.1.Final.tar.gz -C /opt
rm /tmp/jboss*.gz
