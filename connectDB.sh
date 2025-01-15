#!/bin/bash
#       Logic
# change dir to  $1 ->cd
# check  permissions
# output connected succes --> list tables ->
#----------------------------------------------

#source $PWD/var.sh [INTEGRATED IN >>> db.sh]

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


((connect_choice--)) # to be used as index [zero-based]

db_name="${DB_array[$connect_choice]}"
current_DB_path="$MainDIR/$db_name"
clear
echo -e "${GREEN}✔✔ <$db_name> DB connected"


#----------------------------
#HERE WHERE OUR STORY BEGIN
source $PWD/table.sh