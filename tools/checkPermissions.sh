#!/bin/bash

if [ $# -gt 0  ]; then
    if [ ! -w "$1" ] || [ ! -x "$1" ] || [ ! -r "$1" ]; then
        echo "permission is denid. can't create DB inside $1"
        echo "if you want to add permmissions , (sudo passwd needed ) y/n"
        read choice
        if [[ $choice == "y" ]]; then
            sudo chmod 777 $1

        else
            echo "you can't write inside $1 so you can't create DB here "
            echo "contact your admin to have permissions "

        fi

    fi
fi

