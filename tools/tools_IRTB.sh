#!/bin/bash

source /home/$USER/GIT_SHARE/DBMS_script/var.sh


#---------DEVELOPMENT--CHECK------------


function check_db {
    if [[ ! -d "$current_DB_path" || -z "$db_name" ]]; then
        echo -e "${RED}Error: DB NOT exist!!"
        exit 1
    fi
}


function check_table {
    if [[ ! -f "$current_TB_path" || -z "$tb_name" ]]; then
        echo -e "${RED}Error:  Table NOT EXIST!!"
        exit 1
    fi
}


function check_table_exist
{
    if [ -f "$current_DB_path/$ref"  ]; then
        echo "${RED}Table IS NOT EXIST."
        exit
    fi
}


#---------------------------------------


# [CHECK] READ, WRITE PERMISSIONS
function check_rw_permission
{
    if [ ! -r $current_DB_path ] || [ ! -w $current_DB_path ]; then
        echo -e "${RED} Permission Denied."
        exit
    fi
}

#------------------
check_db
check_table
check_table_exist
check_rw_permission
#------------------

# check if the input empty or null(if it is unique or null)
function check_empty_null_input
{

    declare -n ref=$1 #input
    local field=$2
    local dtype=$3
    local constraint=$4
    declare -n ref_choice=$5 #<------------#taking it from outside for change

    while [ -z "$ref" ]; do

        #[CHECK] EMPTY OR NULL INPUT

        if [[ "$constraint" == "NULL" || "$constraint" == "UNIQUE" ]]; then

            echo -e -n "${BLUE}add nothing [NULL]? (y/n)${WHITE}"
            read -p '> ' choice </dev/tty


            if [[ "$choice" == "y" ]]; then
                
                ref_choice="y" # used in checking constraints and dtypes
                ref="" # to make sure
                echo -e "${GREEN}✔ empty value added"
                break
            fi
        fi

        echo -e "\n${RED}INPUT CAN NOT BE EMPTY!!"
        echo -e "${WHITE}($num/$total_num) FIELD: \"$field_name\""
        echo -e "${GRAY}[NOTE >> t: $dtype | c: $constraint]$WHITE"
        read -p  '> ' input </dev/tty

        ref=$input 
    done
}


# PURPOSE: GET (NUMBER OF COLUMN) FOR FIELD
function get_col_num
{

    #INPUT: FIELD NAME
    # STORE THE FIRST LINE OF THE TABLE FILE AS ARRAY
    # SEARCH ON THE ARRAY BY LOOPING INSIDE IT 
    # IF [FIELDNAME == ELEMENT] RETURN INDEX

    local field_name=$1 # for compare
    local index=1
    IFS=':' read -r -a fields_arr <<< "$(head -1 "$current_TB_path")"


    for element in "${fields_arr[@]}"; do

        if [[ "$field_name" == "$element" ]]; then
            echo "$index"
            return 0
        fi 
        ((index++))
    done

}


# sub-function return 1 if the value exist in the table
function check_value_exist
{
    local input=$1
    local field_name=$2
    local col_num=$3

    
    line_no=0
    # [PROCESS]: READ TABLE FILE
    while IFS= read -r line; do

        #[POCESS] ESCAPE THE FIRST LINE
        ((line_no++))
        if [[ $line_no -eq 1 ]]; then
            continue  
        fi

        # [PROCESS] GET VALUE BASED ON COL NUM
        value=$(echo $line | cut -f"$col_num" -d: )

        # COMPARE INPUT WITH VALUE IN FIELD
        if [[ "$input" == "$value" ]]; then
            return 1 # value repeated!
        fi

    done < $current_TB_path

    return 0 # value unique
}


#the main function to check if the input unique or pk
#if it is unique it close, else loop until get right result
function check_unique_pk
{   
    declare -n ref_input=$1  #1 input
    local field_name=$2  #2 field name
    local constraint=$3  #3 constraint
    local dtype= $4      #4 dtype
    local num=$5         #5 num
    local total_num=$6   #6 total num


    if [[ "$constraint" == "UNIQUE" || "$constraint" == "PK"  ]]; then

        # [PROCES]: GET COLUMN NUMBER
        col_num=$(get_col_num "$field_name")
check_value_exist
        while ! check_value_exist "$ref_input" "$field_name" "$col_num"; do

            echo -e "${RED} INPUT AGAINST <$constraint>"
            echo -e "${RED} VALUE CAN NOT BE REPEATED.\n"

            echo -e "\n$WHITE($num/$total_num) FIELD: \"$field_name\""
            echo -e "$GRAY[NOTE >> t: $dtype | c: $constraint]$WHITE"
            read -p  '> ' input </dev/tty

            ref_input=$input
        done

    fi
}

# helper function to flag the main functon 
# that the input is not string
str_input_condition() 
{
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then 
        return 0  # TRUE
    else 
        return 1  # FALSE
    fi
}

# the main function for checking string 
# if it string end, else loop until getting the right input
function check_string_input
{

    declare -n input_ref=$1  #1 input
    local field_name=$2  #2 field name
    local constraint=$3  #3 constraint
    local dtype=$4      #4 dtype
    local num=$5         #5 num
    local total_num=$6   #6 total num
    local null_choice=$7 #<----------------------------

    if [[ "$dtype" == "STR" ]]; then
        while ! str_input_condition "$input_ref"; do

            echo -e "${RED}WRONG DTYPE! Enter STRING\n"

            # [ENTER]: NAME
            echo -e "\n$WHITE($num/$total_num) FIELD: \"$field_name\""
            echo -e "$GRAY[NOTE >> t: $dtype | c: $constraint]$WHITE"
            read -p  '> ' input </dev/tty

            # [CHECK] NOTNULL, NULL, UNIQUE, PK
            check_empty_null_input input "$field_name" "$dtype" "$constraint" null_choice 
            check_unique_pk input "$field_name" "$constraint" "$dtype" $num $total_num

            input_ref=$input
        done
    fi
}

#----------------------------------------------------------------

int_input_condition() 
{
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        return 0  # TRUE
    else
        return 1  # FALSE
    fi
}


function check_integer_input
{

    declare -n input_ref=$1  #1 input
    local field_name=$2  #2 field name
    local constraint=$3  #3 constraint
    local dtype=$4      #4 dtype
    local num=$5         #5 num
    local total_num=$6   #6 total num
    local null_choice=$7 #<----------------------------

    if [[ "$dtype" == "INT" ]]; then
        while ! int_input_condition "$input_ref"; do

            echo -e "${RED}WRONG DTYPE! Enter INTEGER\n"

            # [ENTER]: NAME
            echo -e "\n$WHITE($num/$total_num) FIELD: \"$field_name\""
            echo -e "$GRAY[NOTE >> t: $dtype | c: $constraint]$WHITE"
            read -p  '> ' input </dev/tty

            # [CHECK] NOTNULL, NULL, UNIQUE, PK
            check_empty_null_input input "$field_name" "$dtype" "$constraint" null_choice 
            check_unique_pk input "$field_name" "$constraint" "$dtype" $num $total_num

            input_ref=$input
        done
    fi
}




float_input_condition() 
{
    if [[ $1 =~ ^-?[0-9]*\.[0-9]+$ || $1 =~ ^-?[0-9]+$ ]]; then
        return 0  # TRUE
    else
        return 1  # FALSE
    fi
}


function check_float_input
{

    declare -n input_ref=$1  #1 input
    local field_name=$2  #2 field name
    local constraint=$3  #3 constraint
    local dtype=$4      #4 dtype
    local num=$5         #5 num
    local total_num=$6   #6 total num
    local null_choice=$7 #<----------------------------

    if [[ "$dtype" == "FLOAT" ]]; then
        while ! float_input_condition "$input_ref"; do

            # IF CHOICE NO TO BE NULL
            # IF IT IS NOT NULL
            echo -e "${RED}WRONG DTYPE! Enter FLOAT\n"
        

            # [ENTER]: NAME
            echo -e "\n$WHITE($num/$total_num) FIELD: \"$field_name\""
            echo -e "$GRAY[NOTE >> t: $dtype | c: $constraint]$WHITE"
            read -p  '> ' input </dev/tty


            # [CHECK] NOTNULL, NULL, UNIQUE, PK
            check_empty_null_input input "$field_name" "$dtype" "$constraint" null_choice
            check_unique_pk input "$field_name" "$constraint" "$dtype" $num $total_num

            input_ref=$input
        done
    fi
}