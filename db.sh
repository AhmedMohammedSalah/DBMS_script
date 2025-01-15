#!/bin/bash
#       Logic
# 
# output:-infinity loop of choices
# alternative


# Load global variables
source ./var.sh

# Function to display the main menu
function display_menu {
    echo -e "\n${BOLD_CYAN}Welcome ${USER} to our Database Management System${NC}"
    echo -e "  ${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "  ${BOLD_BLUE}1.${NC} ${GREEN}Create Database${NC}"
    echo -e "  ${BOLD_BLUE}2.${NC} ${GREEN}List Databases${NC}"
    echo -e "  ${BOLD_BLUE}3.${NC} ${GREEN}Connect to Database${NC}"
    echo -e "  ${BOLD_BLUE}4.${NC} ${RED}Delete Database${NC}"
    echo -e "  ${BOLD_BLUE}5.${NC} ${RED}Exit${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
}

# Main loop
while true; do

    # DB DICONNECTING
    db_name=""
    current_DB_path=""

    display_menu
    read -rp "Enter your choice: " choice
    case $choice in
        1)  clear
            source ./createDB.sh  ;;

        2)  clear
            source ./listDBs.sh   ;;

        3)  clear
            source ./connectDB.sh ;;

        4)  clear
            source ./delDB.sh ;;

        5) clear
           echo -e "${BOLD_YELLOW}Exiting...${NC}"
           exit 
           ;;

        *) clear
           echo -e "${BOLD_RED}Error: Invalid choice."
           echo -e "${NC}Please select a valid option."
           ;;
    esac
done
