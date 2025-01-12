#!/bin/bash
#               Logic
# ./listTB
# remove the $1 choice  table
# check  permissions,confirmation
# output table deleted successfully /n ./listTB
# alternative
source ./var.sh
# before call this file :-
# list all dbs
# let user add the num of desired DB
# pass the name of desired DB to this file

# check if the table exists
if [ -f "$1" ]; then
    # check permission
    ./tools/checkPermissions.sh $1
    read -p "are you sure you want to delete '$1' table? (y/n): " choice
    if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
        rm "$1"
        rm ".$1"
        echo -e "\e[33mTable $1 deleted successfully.\e[0m"
    elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
        echo -e "\e[31mOperation canceled.\e[0m"
        echo -e "\e[32mTable $1 still exists.\e[0m"
    else
        echo -e "\e[35mUnknown choice.\e[0m"
    fi
else
    echo -e "\e[31mTable $1 does not exist.\e[0m"
fi
