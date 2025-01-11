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

#extra permissions:
# check if the entered field already exist or not [X]

# assumptions:
# 1- all created database inside "DBs" directory
# 2- current_DB_path in variables.sh
# 3- db_name in variables.sh
# 4- table can have ZERO or ONE PK
# 5- if the user want to make composite primary key
#    this will be alteration on the table not related to creation


# <time> resriction on the  size of the string for table name
#-----------------------------------------------------------------
# [PATH NEED TO BE CHANGED]
<<<<<<< HEAD
source /home/senussi/GIT_SHARE/DBMS_script/table/tools_CTB.sh
source /home/senussi/GIT_SHARE/DBMS_script/var.sh
#-----------------------------------------------------------------

# TEMP VARS
field_line=""; dtype=""; constraint=""

=======
# source .././var.sh
# for current database path
current_DB_path="/home/ahmed"
>>>>>>> b47a101e260777ae4331b40444adc0d2cd334178

#for the name of the current database
db_name="school"
#[CHECK] PERMISSION ON DB
if [ ! -w "$current_DB_path" ]; then
    echo "permission is denid. can't write inside $db_name"; exit
fi


# <FEEDBACK>
echo "You are in $db_name database"

# [ENTER]: TABLE NAME
echo "Enter table name:"
read table_name

#[CHECK] EMPTY, STRING, EXIST
check_empty table_name "Enter Table Name:"
check_string table_name
check_exist table_name


# <FEEDBACK>
echo "Table named $table_name"

# [ENTER]: NO.FIELDS
echo "Enter number of fields:"
read num_of_fields

# [CHECK] EMPTY, INTEGER, NEGATIVE
check_empty num_of_fields "Enter number of fields:"
check_integer num_of_fields
check_negative num_of_fields
warn_big_input num_of_fields


#[PROCESS]: LOOP NO.Fields TIME
for ((i=1; i<=num_of_fields; i++)); do

    # [ENTER]: FIELD NAME
    echo "Enter field $i:"
    read field

    # [CHECK]: EMPTY, STRING, ENTERED-BEFORE
    check_empty field "Enter field name:"
    check_string field
    check_field_exist field

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
echo "Table created with fields: $field_line"


#CREATE HIDDEN TABLE FILE (META) 
meta_path="$current_DB_path/.$table_name"
touch "$meta_path"


# Save the dictionary to a file
for key in "${!dic_fields[@]}"; do
    echo "$key:${dic_fields[$key]}" >> "$meta_path"
done

