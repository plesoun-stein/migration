#!/bin/bash


apt-get -y update
apt-get -y upgrade
apt-get -y install rsync tcpdump screen mc  autopostgresqlbackup automysqlbackup mariadb-client mariadb-server ansible git postgresql-9.6 postgresql-client-9.6 



cd dirs-and-users
ansible-playbook create-groups.yml
ansible-playbook create-users.yml
ansible-playbook create-add-extragroups.yml
ansible-playbook create-dirs.yml

ln -s /home/srv /srv

/root/wrk/create_dbs.sh


cd dirs-and-users
ansible-playbook create-mysqldirsadnlinks

/root/wrk/import_dbs.sh


