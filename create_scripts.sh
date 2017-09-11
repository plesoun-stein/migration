#!/bin/bash

export MYSQL_ROOT="root"
export MYSQL_PASS="rZK#o4j"

EXPORT_DBS=export_dbs.sh
EXPORT_CREATE=create_empty.sql
EXPORT_GRANTS=create_grants.sql
IMPORT_DBS=import_dbs.sh

WORK_HOME=/root/wrk
WORKING_DIR=migrace_durga
DUMP_DIR=db_dumps


cd ${WORK_HOME}
mkdir ${WORKING_DIR}


cd ${WORKING_DIR}
mkdir ${DUMP_DIR}

###export databazi
echo '#!/bin/bash' > ${EXPORT_DBS}
echo "cd ${DUMP_DIR}" >> ${EXPORT_DBS}


mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -N -e " select concat('mysqldump --triggers --routines --events ',schema_name,' > ',' db_dump_20170911_',schema_name,'.dmp\;') from information_schema.schemata where schema_name not in ('alembiq','alembiq_reader','larpportal','karelkremel','mysql', 'information_schema', 'performance_schema');" >> ${EXPORT_DBS}

chmod 700 ${EXPORT_DBS}
./${EXPORT_DBS}


###import databazi
echo '#!/bin/bash' > ${IMPORT_DBS}
echo "mysql < ${EXPORT_CREATE}" >> ${IMPORT_DBS}
echo "mysql < ${EXPORT_GRANTS}" >> ${IMPORT_DBS}
echo "cd ${DUMP_DIR}" >> ${IMPORT_DBS}

mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -N -e " select concat(' mysql ',schema_name,' < db_dump_20170911_',schema_name,'.dmp\;') from information_schema.schemata where schema_name not in ('alembiq','alembiq_reader','larpportal','karelkremel','mysql', 'information_schema', 'performance_schema');" >> ${IMPORT_DBS}
chmod 700 ${IMPORT_DBS}


###vytrvareni prazdnych db
mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -N -e "select concat('CREATE DATABASE ', schema_name, ' DEFAULT CHARSET \'utf8\' COLLATE \'utf8_general_ci\'\;') from information_schema.schemata where schema_name not in ('mysql', 'information_schema', 'performance_schema');" >> ${EXPORT_CREATE}

###vytvoreni uzivatelu
mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -N -e "select concat('CREATE USER \'',user,'\'\@\'',host,'\'',' IDENTIFIED BY PASSWORD \'',password,'\'\;') from mysql.user where user!='root';"  >> ${EXPORT_CREATE}

###granty
OLD_IFS="${IFS}"
IFS=$'\n'

seznam_grantu=($(mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -e "select concat('show grants for \'',user,'\'\@\'',host,'\'\;') from mysql.user where user!='root';" | grep -v "^concat"))


for each in ${seznam_grantu[@]} 
do
   mysql --user="$MYSQL_ROOT" --password="$MYSQL_PASS" -s -r -N -e "${each}" >> ${EXPORT_GRANTS}
done

IFS="${OLD_IFS}"

sed -i 's/$/;/g' ${EXPORT_GRANTS}


rsync -avhz -e "ssh -i /root/.ssh/key_for_migr" ${WORK_HOME}/${WORKING_DIR} root@185.8.164.74:wrk/




