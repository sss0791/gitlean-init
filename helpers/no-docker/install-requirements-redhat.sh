#!/bin/bash
#nginx
sudo yum -y install nginx

#postgresql
sudo yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

sudo yum -y install postgresql96
sudo yum -y install postgresql96-server

sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl enable postgresql-9.6
sudo systemctl start postgresql-9.6

#node
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

#git - on redhat
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm
sudo yum -y install https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm
sudo yum -y install git2u
