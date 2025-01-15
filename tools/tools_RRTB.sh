#!/bin/bash

#[ALREADY INTEGRATED >> db.sh]
#source /home/$USER/GIT_SHARE/DBMS_script/var.sh


function get_PK_index
{   
    # argument
    local pk_name$1

    # get first line contain fields
    fields_str=$(head -1 "$current_TB_path")

    # separate and store in array
    IFS=":" read -r -a fields_arr <<< "$fields_str"

    # initialze index var
    index=1 #(1-based)

    # loop over array
    for element in "${fields_arr[@]}"; do
        if [[ "$pk_name" == "$element" ]]; then
            echo "$index"
        fi
        ((index++))
    done
}


function search_value_in_pk {

    # argument
    local pk_name=$1 # pk name
    local input=$2  #input value to search

    # refrence to alter : we will alter them
    declare -n ref_line_no=$3
    declare -n ref_line=$4

    # get index for pk
    pk_index=$(get_PK_index "$pk_name")


    # line var
    line_no=0

    while IFS= read -r line; do

        #follow line no
        ((line_no++))

        #escape first line
        if [[ $line_no -eq 1 ]]; then
            continue  
        fi

        # get value in the current line of pk column
        value=$(echo "$line" | cut -f"$pk_index" -d:)

        # compare input with value
        if [[ "$input" == "$value" ]]; then #<---------
            ref_line_no=$line_no
            ref_line=$line
            return
        fi

    done < "$current_TB_path"  

    # if it is not exist
    echo -e "${RED}VALUE YOU ENTERED NOT EXIST!"
}


