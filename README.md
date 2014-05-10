Vagrant: creating Xubuntu Trusty (14.04 version) 32 or 64 bit
=======

In this repository there's all you need to create a virtual machine for Virtual Box with vagrant.

The machine you'll create it's a Xubuntu Trusty (14.04) 32 or 64 bit.

### Xubuntu Android Developer

This machine will have installed:
* JDK 7
* ADT Bundle 22

### Xubuntu Java Developer

This machine will have installed:
* JDK 6
* Eclipse JEE Kepler (with JBoss tools and SVN plugin)
* JBoss 7.1.1
* Apache2
* PHP 5
* MySql
* phpMyAdmin
* Chrome Browser
* Git
* Maven
* DBeaver 2.4.0

### Xubuntu Server

This machine will have installed:
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
* Chrome Browser

## Prerequisite
The only application you must have installed on your computer are:
* Vagrant: http://www.vagrantup.com/
* Virtualbox: https://www.virtualbox.org/

## Step 1

After you installed vagrant on your computer, choice a folder where you put:
* Vagrantfile
* bootestrap.sh

For example: c:\vagrant\xubuntu-trusty

## Step 2

Digit on a shell **vagrant up**.

Now wait that the script creating the machine and install some software which you'll need for your development environment.

## Step 3

Digit on a shell **vagrant halt** to close the machine.

## Step 4

Re-digit on a shell **vagrant up** and now you can login with credentials:
* User: *vagrant*
* Password: *vagrant*

## Step 5

You have finished! :-)

Enjoy!
