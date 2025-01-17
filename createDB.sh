#!/bin/bash
#       Logic
# create folder from $1 ->mkdir
# check name permissions repeated
# output db created successfully
# alternative

source ./var.sh
./tools/checkPermissions.sh $MainDIR

while true; do

    #-- SENU----------------------------------------------
    echo -e "\n${WHITE}Enter DB Name"
    echo -e "${GRAY}(type 'exit' to quit):${WHITE}"
    read -p '> ' dbname
    #-----------------------------------------------------

    # Check if input is empty or
    # contain special characters
    # or numbers at the start
    if [[ -z "$dbname" || $dbname =~ ^[0-9] || "$dbname" =~ [^a-zA-Z_] || "$dbname" == *\\* ]]; then
        echo -e "${BOLD_RED}Invalid database name. Please ensure that it:${NC}"
        echo -e "${YELLOW}- Is not empty${NC}"
        echo -e "${YELLOW}- Does not start with a number${NC}"
        echo -e "${YELLOW}- Contains only alphanumeric characters and underscores${NC}"
        echo -e "${BOLD_RED}Please try again.${NC}"

    elif [[ "$dbname" == "exit" ]]; then
        echo -e "${BOLD_YELLOW}Exiting...${NC}"
        break
    elif [[ -d "$MainDIR/$dbname" ]]; then
        echo -e "${BOLD_RED}Error:${NC} Database '${BOLD_YELLOW}$dbname${NC}' already exists. Please choose a different name."

    else
        mkdir -p "$MainDIR/$dbname" #<---SENU---
        # -p option to create parent directories if they don't exist
        clear
        echo -e "${BOLD_GREEN}✔✔ DB '$dbname' created successfully${NC}"
        break
    fi
done
