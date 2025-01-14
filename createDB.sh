#!/bin/bash
#       Logic
# create folder from $1 ->mkdir
# check name permissions repeated
# output db created successfully
# alternative

source ./var.sh

./tools/checkPermissions.sh $MainDIR

while true; do
    read -p "Enter the name of the database (or type 'exit' to quit): " dbname
    
    # Check if input is empty or 
    # contain special characters 
    # or numbers at the start
    if [[ -z "$dbname" || $dbname =~ ^[0-9] || "$dbname" =~ [^a-zA-Z0-9_] ]]; then
        echo -e "${BOLD_RED}Invalid database name. Please ensure that it:${NC}"
        echo -e "${YELLOW}- Is not empty${NC}"
        echo -e "${YELLOW}- Does not start with a number${NC}"
        echo -e "${YELLOW}- Contains only alphanumeric characters and underscores${NC}"
        echo -e "${BOLD_RED}Please try again.${NC}"

    elif [[ "$dbname" == "exit" ]]; then
        echo -e "${BOLD_YELLOW}Exiting...${NC}"
        break
    else
        mkdir -p "$MainDIR/$dbname"
        # -p option to create parent directories if they don't exist
        echo -e "${BOLD_GREEN}Database '$dbname' created successfully${NC}"
        break
    fi
done