#!/bin/bash


apt-get -y update
apt-get -y upgrade
apt-get -y install rsync tcpdump screen mc  autopostgresqlbackup automysqlbackup mariadb-client mariadb-server ansible git
