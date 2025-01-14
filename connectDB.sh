#!/bin/bash
#       Logic
# change dir to  $1 ->cd
# check  permissions
# output connected succes --> list tables ->
# alternative



source /home/$USER/GIT_SHARE/DBMS_script/var.sh



source listDBs.sh
# DB_array : get name based choice as index.
# counter  : check range of choices.

# [ENTER]
echo "enter your choice: "
read connect_choice


while [[ $connect_choice -le 0 ||  $connect_choice -gt $counter ]]; do
    echo -e "${RED}Wrong choice!"
    echo -e "${WHITE}enter your choice: "
    read -p '> ' connect_choice
done

db_name="${DB_array[$connect_choice]}"

echo -e "${GREEN}✔✔ <$db_name> DB connected"