#!/bin/bash

# ./listTB.sh
# insertrowTB.sh table-name

#               Logic
# get the fields from .$1
# for loop to enter field and check constraints
# check unique of pk
# check  permissions,
# <time>if <FK> ==> check pk of another table
# output 1 row affected  /n ./listTB
# alternative

#--------------------------------------------------
# INCLUDE
source /home/$USER/GIT_SHARE/DBMS_script/var.sh
source /home/$USER/GIT_SHARE/DBMS_script/tools/tools_IRTB.sh

#---------DEVELOPMENT--CHECK------------------------
check_db            # [CHECK] DB not chosen
check_table         # [CHECK] Table not chosen
check_table_exist   # [CHECK] TABLE EXIST
check_rw_permission # [CHECK] READ, WRITE PERMISSIONS
#---------------------------------------------------

field_line=""; num=1;
total_num=$(wc -l < "$current_DB_path/.$tb_name")

while  IFS= read -r line; do

    # [VARS STORE]: FIELD-NAME, DTYPE, CONSTRAINT 
    field_name=$(echo $line | cut -f1 -d:)
    dtype=$(echo $line | cut -f2 -d:)
    constraint=$(echo $line | cut -f3 -d:)
    
    

    # [ENTER]: NAME
    echo -e "\n$WHITE($num/$total_num) FIELD: \"$field_name\""
    echo -e "$GRAY[NOTE >> t: $dtype | c: $constraint]$WHITE"
    read -p  '> ' input </dev/tty

    # [CHECK] IF INPUT IS EMPTY OR NULL 
    check_empty_null_input input "$field_name" "$dtype" "$constraint"

    #[CHECK] UNIQUE
    check_unique input "$field_name" "$constraint" "$dtype" $num $total_num



    #[PROCESS]: FOR VIEW
    ((num++))


    # [PROCESS]: INSERTION
    # field_line=... <pass>


done < "$current_DB_path/.$tb_name"
