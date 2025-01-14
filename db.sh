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
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "  ${BOLD_BLUE}1.${NC} ${GREEN}Create Database${NC}"
    echo -e "  ${BOLD_BLUE}2.${NC} ${GREEN}List Databases${NC}"
    echo -e "  ${BOLD_BLUE}3.${NC} ${GREEN}Connect to Database${NC}"
    echo -e "  ${BOLD_BLUE}4.${NC} ${RED}Delete Database${NC}"
    echo -e "  ${BOLD_BLUE}5.${NC} ${RED}Exit${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
}

# Main loop
while true; do
    display_menu
    read -rp "Enter your choice: " choice
    case $choice in
        1)  
            ./createDB.sh
            ;;
        2)
            ./listDBs.sh
            ;;
        3)  
            source ./connectDB.sh 
            ;;
        4) 
            ./delDB.sh 
            ;;
        5) 
            echo -e "${BOLD_YELLOW}Exiting...${NC}"
            exit 0
            ;;
        *)  
            echo -e "${BOLD_RED}Error:${NC} Invalid choice. Please select a valid option."
            ;;
    esac
done