#!/bin/bash
#               Logic
# ./listTB
# remove the $tb_name choice  table
# check  permissions,confirmation
# output table deleted successfully /n ./listTB
# alternative
# before call this file :-
# list all dbs
# let user add the num of desired DB
# pass the name of desired DB to this file

# check if the table exists
if [ -f "$tb_name" ]; then
    # check permission
    ./tools/checkPermissions.sh $tb_name
    read -p "are you sure you want to delete '$tb_name' table? (y/n): " choice
    if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
        rm "$tb_name"
        rm ".$tb_name"
        echo -e "\e[33mTable $tb_name deleted successfully.\e[0m"
    elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
        echo -e "\e[31mOperation canceled.\e[0m"
        echo -e "\e[32mTable $tb_name still exists.\e[0m"
    else
        echo -e "\e[35mUnknown choice.\e[0m"
    fi
else
    echo -e "\e[31mTable $tb_name does not exist.\e[0m"
fi
