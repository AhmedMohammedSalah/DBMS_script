#!/bin/bash

#       Logic
# list folder from base dir -> ls [X]
# check permissions [X]
# output list dirs of dbs [X]
# alternative
# <time> dir cp $1 to base_dir

source ./var.sh

# [CHECK] READ PERMISSION
if [ ! -r $MainDIR ]; then
    echo -e "${RED} Reading Permission Denied "
    exit
fi

# [PROCESS] gather DB names
mapfile -t DB_array < <(ls "$MainDIR" | grep -v /)

# [CHECK] EMPTY
if [ -z "${DB_array[0]}" ]; then
    echo -e "${RED} EMPTY"
fi

#[OUTPUT]
counter=0
for db_element in $DB_array; do
    ((counter++))
    echo "$counter- $db_element"
done


# counter and db_array will be used in integation
