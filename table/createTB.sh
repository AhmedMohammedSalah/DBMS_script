#!/bin/bash

#               Logic
# create file  from $1 ->touch [X]
# CREATE another file .$1 -> touch ==> for meta data  [X]
# fields + <PK> + <time> --<FK constraint> [X][]
#.$1 field_name  : Field_type : field_constraint [X] 
# for on .$1 separated by : [X]
#  $1 to add columns name  [X]
# check name [X] ,permissions [X] repeated [X] 
# output table created successfully  [X]
# alternative
#-------------------------------------------------------------------

# extra permissions:
# check if the entered field already exist or not [X]

# assumptions [UPDATED]:
# 0- assume you cloned project in "GIT-SHARE" dir
# 1- all created database inside "databases" dir in HOME directory 
# 2- current_DB_path in var.sh
# 3- db_name in var.sh
# 4- table must have ONE PK
# 5- system is too simple too handle composite primary key


# <time> resriction on the  size of the string for table name
#-----------------------------------------------------------------
# [PATH NEED TO BE CHANGED]: GIT_SHARE/DBMS_script
source ../tools/tools_CTB.sh
source ../var.sh

#-----------------------------------------------------------------

# TEMP VARS
field_line=""; dtype=""; constraint=""

#-----------------------------
#CHECK FOR DEVELOPMENT

# [CHECK] if the current DB not chosed
if [ -z "$db_name" ]; then
    echo -e "${RED} error: the db not chosed!!"
    exit
fi
#-----------------------------

#for the name of the current database
# db_name="school"

#[CHECK] PERMISSION ON DB
# if [ ! -w "$current_DB_path" ]; then
#     echo "permission is denid. can't write inside $db_name"; exit
# fi

# <FEEDBACK>
echo -e "${GRAY}Inside [$db_name] DB\n"

# [ENTER]: TABLE NAME
echo -e "${WHITE}Enter table name:"
read -p "> " table_name

#[CHECK] EMPTY, STRING, EXIST
check_empty table_name "Enter Table Name:"
check_string table_name
check_exist table_name


# <FEEDBACK>
echo -e "${GREEN}✔ Table named <$table_name>\n"
echo -e "${GRAY}[$db_name] DB:\n=>[$table_name] Table\n"

# [ENTER]: NO.FIELDS
echo -e "${WHITE}Enter number of fields:"
read -p "> " num_of_fields

# [CHECK] EMPTY, INTEGER, NEGATIVE
check_empty num_of_fields "Enter number of fields:"
check_integer num_of_fields
check_negative num_of_fields
warn_big_input num_of_fields

# <FEEDBACK>
echo -e "${GREEN}✔ $num_of_fields fields will be entered"

#[PROCESS]: LOOP NO.Fields TIME
for ((i=1; i<=num_of_fields; i++)); do

    # [ENTER]: FIELD NAME
    echo -e "${GRAY}\nField $i:\n${WHITE}Enter field name:"
    read -p "> " field

    # [CHECK]: EMPTY, STRING, ENTERED-BEFORE
    check_empty field "Enter field name:"
    check_string field
    check_field_exist field

    # <FEEDBACK>
    echo -e "${GREEN}✔ field named <$field>\n"

    # [ENTER]: DTYPE, CONSTRAINT
    add_dtype dtype
    add_constraint constraint

    # [PROCESS]: insert inside the dictionary
    dic_fields["$field"]="$dtype:$constraint" 

    # [PROCESS]" insert + Add delimiter
    field_line="$field_line$field"
    if [ $i -lt $num_of_fields ]; then
        field_line="$field_line:"
    fi
done


#[CHECK] PRIMARY KEY EXISTENCE + HANDLLING
PK_handle

#-----------------------------------------------------------
# if user kill the process for any reason,
# the file will not created until the user finish all inputs
# and checking all permisions
#--------ACTION----------------------------------------------

# CREATE TABLE FILE + Save fields to a file
table_path="$current_DB_path/$table_name"
touch "$table_path"
echo "$field_line" > "$table_path"

# <FEEDBACK>
echo -e "${GREEN}✔✔ Table created successfully!"



#CREATE HIDDEN TABLE FILE (META) 
meta_path="$current_DB_path/.$table_name"
touch "$meta_path"


# Save the dictionary to a file
for key in "${!dic_fields[@]}"; do
    echo "$key:${dic_fields[$key]}" >> "$meta_path"
done



