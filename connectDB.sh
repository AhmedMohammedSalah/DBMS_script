#!/bin/bash
#       Logic
# Change directory to $1 -> cd
# Check permissions
# Output connected success --> list tables
#----------------------------------------------

#source $PWD/var.sh [INTEGRATED IN >>> db.sh]

source listDBs.sh
# DB_array : get name based choice as index.
# counter  : check range of choices.

# [ENTER]
echo "enter your choice: "
read connect_choice

# LOOP UNTIL GET RIGHT CHOICE
while [[ $connect_choice -le 0 || $connect_choice -gt $counter || $connect_choice == *"/"* || $connect_choice == *"\\"* || $connect_choice == *"."* ]]; do
    echo -e "${RED}Wrong choice! Input cannot contain '/', '\\', or '.'"
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
