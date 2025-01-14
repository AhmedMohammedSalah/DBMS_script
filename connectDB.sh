#!/bin/bash
#       Logic
# change dir to  $1 ->cd
# check  permissions
# output connected succes --> list tables ->
# alternative


# INCLUDE
source /home/$USER/GIT_SHARE/DBMS_script/var.sh

# INCLUDE
source listDBs.sh
# DB_array : get name based choice as index.
# counter  : check range of choices.

# [ENTER]
echo "enter your choice: "
read connect_choice

# LOOP UNTIL GET RIGHT CHOICE
while [[ $connect_choice -le 0 ||  $connect_choice -gt $counter ]]; do
    echo -e "${RED}Wrong choice!"
    echo -e "${WHITE}enter your choice: "
    read -p '> ' connect_choice
done


#----[DEBUG]----------
# echo "printing db array: "
# for i in "${DB_array[@]}"; do
#     echo "$i"
# done
#---------------------

((connect_choice--)) # because of array is zero based

db_name="${DB_array[$connect_choice]}"

echo -e "${GREEN}✔✔ <$db_name> DB connected"