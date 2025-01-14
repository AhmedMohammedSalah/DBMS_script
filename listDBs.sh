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
DB_lst=$(ls $MainDIR | grep -v /)

# [CHECK] EMPTY
if [ -z "$DB_lst" ]; then
    echo -e "${RED} EMPTY"
fi

#[OUTPUT]
counter=1
for db_element in $DB_lst; do
    echo "$counter- $db_element"
    ((counter++))
done