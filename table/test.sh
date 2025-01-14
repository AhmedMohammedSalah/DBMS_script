#!/bin/bash

source /home/$USER/GIT_SHARE/DBMS_script/var.sh

 
function check_empty_null_input
{
    declare -n ref=$1 #input
    local field=$2
    local dtype=$3
    local constraint=$4

    while [ -z "$ref" ]; do

        #[CHECK] EMPTY OR NULL INPUT

        if [[ "$constraint" == "NULL" || "$constraint" == "UNIQUE" ]]; then

            echo -e -n "${BLUE}add nothing [NULL]? (y/n)${WHITE}"
            read -p '> ' choice </dev/tty


            if [[ "$choice" == "y" ]]; then
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






#-------------------------------------------
    # PURPOSE: INPUT EXISTENCE IN TABLE FILE
    # GOAL: ACCESS COLUMN BY FIELD NAME

    # [FUNCTION]: check_value_exist

        # FIRST, GET (NUMBER OF COLUMN) FOR FIELD [FUNCTION]
        # SECOND, READ THE FILE
        # GET VALUE USING COLUMN NUMBER
        #COMPARE INPUT WITH VALUE IN FIELD ?
        #IF THE VALUE EXIST RETURN 1
        # ELSE THE LOOP CONTINUE AND RETURN 0


    #WHILE (FUNCTION INPUT == 1):
        # ECHO VALUE CAN NOT BE REPEATED, AGAINST $CONSTRAINT
        # ENTER AGAIN INPUT
#-------------------------------------------


#FUNCTION: GET_COL_NUM 
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


function check_unique
{   
    # function deped on that the variable will be seen in the current scope the funcion call on
    declare -n ref_input=$1  #1 input
    local field_name=$2  #2 field name
    local constraint=$3  #3 constraint
    local dtype= $4      #4 dtype
    local num=$5         #5 num
    local total_num=$6   #6 total num


    if [[ "$constraint" == "UNIQUE" ]]; then

        # [PROCES]: GET COLUMN NUMBER
        col_num=$(get_col_num "$field_name")

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

    check_pk input "$field_name" "$constraint" "$dtype" $num $total_num


    #[PROCESS]: FOR VIEW
    ((num++))


    # [PROCESS]: INSERTION
    # field_line=... <pass>


done < "$current_DB_path/.$tb_name"





