#!/bin/bash


mydir=$(pwd)

apt-get -y update
apt-get -y upgrade
apt-get -y install rsync tcpdump screen mc  autopostgresqlbackup automysqlbackup mariadb-client mariadb-server ansible git postgresql-9.6 postgresql-client-9.6 



cd dirs-and-users
ansible-playbook create-groups.yml
ansible-playbook create-users.yml
ansible-playbook create-add-extragroups.yml
ansible-playbook create-dirs.yml

rmdir /srv 
ln -s /home/srv /srv

/root/wrk/migrace_durga/create_dbs.sh


cd $mydir/dirs-and-users
ansible-playbook create-mysqldirsadnlinks

/root/wrk/import_dbs.sh


