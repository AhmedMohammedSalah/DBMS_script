#!/bin/bash
#       Logic
# remove $1 from dirs -> rmdir || rm -r
# check  permissions , warning message
# output:- deleted succes --> listDBs
# alternative
source ./var.sh
# before call this file :- 
# list all dbs 
# let user add the num of desired DB 
# pass the name of desired DB to this file

# check if the DB exists
if [ -d "$1" ]; then
    # check permission
    ./tools/checkPermissions.sh $1
    read -p "are you sure you want to delete '$1' DB? (y/n): " choice
    if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
        rmdir "$1" || rm -r "$1"
        echo -e "\e[33mDatabase $1 deleted successfully.\e[0m"
    elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
        echo -e "\e[31mOperation canceled.\e[0m"
        echo -e "\e[32mDatabase $1 still exists.\e[0m"
    else
        echo -e "\e[35mUnknown choice.\e[0m"
    fi
    else 
        echo -e "\e[31mDatabase $1 does not exist.\e[0m"
fi



