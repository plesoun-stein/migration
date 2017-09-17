#!/bin/bash


cd dirs-and-users
ansible-playbook create-groups.yml
ansible-playbook create-users.yml
ansible-playbook create-add-extragroups.yml
ansible-playbook create-dirs.yml

rmdir /srv 
ln -s /home/srv /srv

cp -a /var/lib/mysql/* /home/srv/maria/

systemctl daemon-reload

systemctl start mariadb.service

cd /root/wrk/migrace_durga
./create_dbs.sh

#cd $mydir/dirs-and-users
#ansible-playbook create-mysqldirsadnlinks

cd /root/wrk/migrace_durga
./import_dbs.sh


