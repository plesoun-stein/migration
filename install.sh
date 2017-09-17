#!/bin/bash


apt-get -y update
apt-get -y upgrade
apt-get -y install rsync tcpdump screen mc  autopostgresqlbackup automysqlbackup mariadb-client mariadb-server ansible git postgresql-9.6 postgresql-client-9.6 


systemctl stop mariadb.service
usermod -l maria mysql
groupmod -n mariadb mysql

systemctl enable mariadb.service
systemctl start mariadb.service

