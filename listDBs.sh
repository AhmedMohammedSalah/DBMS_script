#!/bin/bash
#       Logic
# list folder from base dir -> ls [X]
# check permissions [X]
# output list dirs of dbs [X]
# alternative
# <time> dir cp $1 to base_dir

# [CHECK] READ PERMISSION
if [ ! -r "$MainDIR" ]; then
    echo -e "${BOLD_RED}Error:${NC} ${RED}Reading Permission Denied${NC}"
    exit
fi

# [PROCESS] gather DB names
readarray -t DB_array <<< "$(ls -1 "$MainDIR" | grep -v /)"

# [CHECK] EMPTY
if [ -z "${DB_array[0]}" ]; then
    echo -e "${BOLD_RED}Error:${NC} ${RED}No databases found. Directory is EMPTY.${NC}"
    exit
fi

counter=1
for db in "$MainDIR"/*/; do
    db_name=$(basename "$db")
    echo -e "\e[33m$counter.\e[0m \e[32m$db_name\e[0m"
    ((counter++))
done

# counter and db_array will be used in integration