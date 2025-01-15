#!/bin/bash
<<<<<<< HEAD

#               Logic
# list tables  -> ls -l| cut -f10 -d" "|add index to each element   *current path
# check permissions
=======
#               Logic
# list tables  -> ls -l| cut -f10 -d" "|add index to each element   *current path
# check  permissions
>>>>>>> 35d07fa9b2c13fe3e76d934e7a97a6c1b6425bf5
# output tables   
# alternative -r 
#-----------------

#source $PWD/var.sh [INTEGRATED IN >>> db.sh]

# For development

#---------DEVELOPMENT--CHECK-------------------

# [CHECK] if the current DB is not chosen
if [ -z "$db_name" ]; then
    echo -e "\e[31mError: The DB is not chosen!!\e[0m"
    exit
fi

#----------------------------------------------

# [CHECK] READ PERMISSION
if [ ! -r "$current_DB_path" ]; then
    echo -e "\e[31mReading Permission Denied\e[0m"
    exit
fi

# [PROCESS] gather table names
readarray -t table_lst <<< "$(ls -1 "$current_DB_path" | grep -v /)"

# [CHECK] EMPTY
if [ "${#table_lst[0]}" -eq 0 ]; then
    echo -e "\e[31mEMPTY DB\e[0m"
    return
fi

# [OUTPUT]
Tcounter=0
for table in "${table_lst[@]}"; do
    ((Tcounter++))
    echo "$Tcounter- $table"
done

# variable which will be used in connection
# Tcounter
# table_lst