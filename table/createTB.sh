#!/bin/bash

#               Logic
# create file  from $1 ->touch [X]
# CREATE another file .$1 -> touch ==> for meta data  []
# fields + <PK> + <time> --<FK constraint> []
#.$1 field_name  : Field_type : field_constraint [] 
# for on .$1 separated by : []
#  $1 to add columns name  [X]
# check name [X] ,permissions [X] repeated [X] 
# output table created successfully  
# alternative
#-----------------------------------------

#extra permissions:
# check if the entered field already exist or not

# assumptions:
# 1- all created database inside "DBs" directory
# 2- current_DB_path in variables.sh
# 3- db_name in variables.sh

# refrences
#[check input type]
# https://askubuntu.com/questions/1174142/shell-script-to-check-if-input-is-a-string-integer-float
#[loop in dictionary (associative array)]
# https://stackoverflow.com/questions/3112687/how-to-iterate-over-associative-arrays-in-bash


# <time>
# resriction on the  size of the string for table name
#-----------------------------------------

#GLOBAL VARIABLES
declare -gA dic_fields # to store: field name : [dtype, constraint]


# FUNC: CHECK EMPTY INPUT NAME ?
function check_empty
{
    declare -n ref=$1 
    msg=$2

    while [ -z "$ref" ]; do
        echo "Name cannot be empty."
        echo "$msg"
        read new_var  
        ref=$new_var 
    done
}


# FUNC: CHECK STRING

#1
str_condition() 
{
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then 
        return 0  # TRUE
    else 
        return 1  # FALSE
    fi
}

#2
function check_string
{
    declare -n ref=$1

    while ! str_condition "$ref"; do
        echo "Invalid input, enter string, please:"
        read name
        ref=$name
    done
}



# FUNC: CHECK INTEGER

#1
int_condition() 
{
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        return 0  # TRUE
    else
        return 1  # FALSE
    fi
}

#2
function check_integer
{
    declare -n ref=$1
    while ! int_condition "$ref"; do
        echo "Invalid input, enter an integer, please:"
        read number
        ref=$number
    done
}


# FUNC: CHECK NEGATIVE NUM
function check_negative
{
    declare -n ref=$1

    while [ "$ref" -lt 0 ]; do
        echo "Invalid number"
        echo "enter again, please:"
        read number

        # [CHECK] EMPTY INPUT ?
        check_empty number "Enter number of fields:"

        # [CHECK] INTEGER ?
        check_integer number

        ref=$number  

    done

}

#FUNC: CHECK FIELD ENTERED BEFORE
function field_exist_condition
{
    entered_field=$1
    for key in "${!dic_fields[@]}"; do
        if [[ "$key" == "$entered_field" ]]; then
            return 1
        fi
    done
    return 0
}


function check_field_exist
{
    declare -n ref=$1
    while ! field_exist_condition "$ref"; do
        echo "already exist, enter name again:"
        read field_name
        ref=$field_name
    done
}



#--------------------------------------------------------

# [PATH NEED TO BE CHANGED]
# source .././var.sh
# for current database path
current_DB_path="/home/ahmed"

#for the name of the current database
db_name="school"
#[CHECK] PERMISSION ON DB
if [ ! -w "$current_DB_path" ]; then
    echo "permission is denid. can't write inside $db_name"
    exit
fi


# FEEDBACK
echo "You are in $db_name database"

# [ENTER]: TABLE NAME
echo "Enter table name:"
read table_name

#[CHECK] EMPTY, STRING
check_empty table_name "Enter Table Name:"
check_string table_name

# [CHECK] TABLE NAME EXIST ?
while [ -f "$current_DB_path/$table_name" ]; do

    echo "Table name already exists. Enter a different table name:"
    read table_name

    # [CHECK] EMPTY, STRING
    check_empty table_name "Enter Table Name:"
    check_string table_name

done

# FEEDBACK
echo "Table named $table_name"

# [ENTER]: NO.FIELDS
echo "Enter number of fields:"
read num_of_fields

# [CHECK] EMPTY, INTEGER, NEGATIVE
check_empty num_of_fields "Enter number of fields:"
check_integer num_of_fields
check_negative num_of_fields

# [CHECK]: BIG INPUT?
if [ "$num_of_fields" -gt 20 ]; then
    echo "More than 20 fields, are you sure? (y/n)"

    # CONTINUE ?
    read choice

    if [ "$choice" == "n" ]; then
        # [ENTER]
        echo "Enter number of fields again:"
        read num_of_fields

        # [CHECKs]
        check_empty num_of_fields "Enter number of fields:"
        check_integer num_of_fields
        check_negative num_of_fields
    fi
fi


# ADD FIELDS

# to add in the table file
field_line=""

for ((i=1; i<=num_of_fields; i++)); do

    # [ENTER]: FIELD NAME
    echo "Enter field $i:"
    read field


    # [CHECK]: FIELD ENTERED BEFORE ?
    check_field_exist field

    # [ENTER]: DTYPE
    echo "Enter dtype for $field:"
    read dtype

    # [ENTER]: CONSTRAINT
    echo "Enter constraint for $field:"
    read constraint


    # [PROCESS]: insert inside the dictionary
    dic_fields["$field"]="$dtype:$constraint" 


    # [PROCESS]" insert + Add delimiter
    field_line="$field_line$field"
    if [ $i -lt $num_of_fields ]; then
        field_line="$field_line:"
    fi
done


# if the user kill the process for any reason
# the file will not created until the user finish all inputs
# and checking all permisions
#--------ACTION--------------------------

# CREATE TABLE FILE + Save fields to a file
table_path="$current_DB_path/$table_name"
touch "$table_path"
echo "$field_line" > "$table_path"

# Feedback
echo "Table created with fields: $field_line"


#CREATE HIDDEN TABLE FILE (META) 
meta_path="$current_DB_path/.$table_name"
touch "$meta_path"


# Save the dictionary to a file
for key in "${!dic_fields[@]}"; do
    echo "$key:${dic_fields[$key]}" >> "$meta_path"
done

