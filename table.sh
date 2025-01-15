#!/bin/bash
#       Logic
# 
# output:-infinity loop of choices
# alternative

#source $PWD/var.sh [INTEGRATED IN >>> db.sh]

function display_T_menu 
{   
    
    echo -e "\n${BOLD_CYAN}CONNECTED TO <$db_name> DB${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "${BOLD_BLUE}1.${NC} ${GREEN}Create Table ${NC}"
    echo -e "${BOLD_BLUE}2.${NC} ${GREEN}List Table [related to DB]${NC}"
    echo -e "${BOLD_BLUE}3.${NC} ${GREEN}Connect Table${NC}"
    echo -e "${BOLD_BLUE}4.${NC} ${RED}Drop Table${NC}"
    echo -e "${BOLD_BLUE}5.${NC} ${RED}DB $db_name DISCONNECT${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"    
}


while true; do

    # [RESET]: DISCONNECT TABLE
    tb_name=""
    current_TB_path=""
    current_meta_TB_path=""

    # MENU
    display_T_menu 

    # ENTER
    read -rp "Enter your choice: " T_cmd_choice

    # PROCESS
    case $T_cmd_choice in
        1)
            clear
            source ./table/createTB.sh
            ;;
        2)
            clear
            source ./table/listTB.sh
            ;;
        3)
            clear
            source ./table/connectTB.sh
            ;;
        4)
            clear
            source ./table/dropTB.sh
            ;;
        5)
            clear
            echo "DB $db_name DISCONNECTED"
            source .var.sh
            break 
            ;;
        *)
            clear
            echo -e "${BOLD_RED}Error: Invalid choice."
            echo -e "${NC}Please select a valid option."
            ;;
    esac
done
clear
