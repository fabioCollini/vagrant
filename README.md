Vagrant: creating Xubuntu Trusty 32 bit 
=======

In this branch there is all you need to create a virtual machine with vagrant.

## Step 1

After you installed vagrant on your computer, choice a folder where you put:
* Vagrantfile
* bootestrap.sh

For example: c:\vagrant\xubuntu-trusty

## Step 2

Digit on a shell **vagrant up**

Now wait that the script finish to create the machine and install some software you will need in your development environment.

You have finished! :-)

The machine you create will be an Xubuntu Trusty (14.04) 32 bit with:
* JDK 6
* JDK 7
* Jenkins CI (already configured)
* SonarQube (already connected to MySql database)
* Nexus Sonatype
* Maven 3
* Git
* Apache2
* PHP 5
* MySql
* phpMyAdmin
* Eclipse Kepler (with JBoss tools and SVN plugin)
* JBoss 7.1.1
* Chrome Browser
