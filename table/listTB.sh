#!/bin/bash


#               Logic
# list tables  -> ls -l| cut -f10 -d" "|add index to each element   *current path

# check  permissions
# output tables   
# alternative -r 

source /home/$USER/GIT_SHARE/DBMS_script/var.sh

#---------DEVELOPMENT--CHECK-------------------
# [CHECK] if the current DB not chosed
if [ -z "$db_name" ]; then
    echo -e "${RED} error: the DB not chosed!!"
    exit
fi
#----------------------------------------------

# [CHECK] READ PERMISSION
if [ ! -r $current_DB_path ]; then
    echo -e "${RED} Reading Permission Denied "
    exit
fi

# [PROCESS] gather table names
table_lst=$(ls $current_DB_path | grep -v /)

# [CHECK] EMPTY
if [ -z "$table_lst" ]; then
    echo -e "${RED} EMPTY DB"
fi

#[OUTPUT]
counter=1
for table in $table_lst; do
    echo "$counter- $table"
    ((counter++))
done
