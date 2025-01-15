#!/bin/bash

if [ $# -gt 0 ]; then
    if [ ! -w "$1" ] || [ ! -x "$1" ] || [ ! -r "$1" ]; then

        #-------[SENU ALTER]----------[too long]-------------------------
        #echo "permission is denid. can't work inside $1"
        #echo "if you want to add permmissions , (sudo passwd needed ) y/n"

        echo -e "${RED}PERMISSION NOT ENOUGH!"
        echo -e "${NC}Enter Your Privilages ? (y/n)"
        #-----------------------------------------------------------------

        

        read choice
        if [[ $choice == "y" ]]; then
            sudo chmod 777 $1

        else
            #-------[SENU ALTER]----------[too long]---------------------
            echo "you can't write inside $1 so you can't create DB here "
            echo "contact your admin to have permissions "

        fi

    fi
fi


# OLD PRINTING: too long
#echo "permission is denid. can't work inside $1"