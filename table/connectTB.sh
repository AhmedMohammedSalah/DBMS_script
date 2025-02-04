#!/bin/bash

#       Logic
# change dir to  $1 ->cd
# check  permissions
# output connected succes --> list tables ->
#----------------------------------------------

source ./table/listTB.sh
#<-----[ALTERED]----
# table_lst : get name based choice as index.
# Tcounter  : check range of choices.

#---------------------------------------
# [MUST CHECK IF THE LIST EMPTY OR NOT]
#---------------------------------------

# [ENTER]
echo "Enter your choice: "
read Tconnect_choice

# LOOP UNTIL GET RIGHT CHOICE AND VALID INPUT
while [[ $Tconnect_choice -le 0 || $Tconnect_choice -gt $Tcounter || $Tconnect_choice =~ [\\/\.] ]]; do
    echo -e "${RED}Invalid choice! Input must be a valid number and cannot contain '/', '\\', or '.'"
    echo -e "${WHITE}Enter your choice: "
    read -p '> ' Tconnect_choice

done

((Tconnect_choice--)) # to be used as index [zero-based]

# CONNECTING Table
tb_name="${table_lst[$Tconnect_choice]}"
current_TB_path="$MainDIR/$db_name/$tb_name"
current_meta_TB_path="$MainDIR/$db_name/.$tb_name" #dot

clear
echo -e "${GREEN}✔✔ <$tb_name> Table connected"

#----------------------------
#HERE WHERE OUR STORY END

function display_TT_menu 
{   
    echo -e "\n${BOLD_CYAN}<$db_name> DB >>> <$tb_name> Table CONNECTED${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "${BOLD_BLUE}1.${NC} ${GREEN}View Table${NC}"
    echo -e "${BOLD_BLUE}2.${NC} ${GREEN}Insert Row${NC}"
    echo -e "${BOLD_BLUE}3.${NC} ${GREEN}Update Row/Cell${NC}"
    echo -e "${BOLD_BLUE}4.${NC} ${GREEN}Export as CSV/Cell${NC}"
    echo -e "${BOLD_BLUE}5.${NC} ${RED}Remove Row${NC}"
    echo -e "${BOLD_BLUE}6.${NC} ${RED}TB $tb_name DISCONNECT${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"    
}

while true; do

    # MENU
    display_TT_menu 

    # ENTER
    read -rp "Enter your choice: " TT_cmd_choice

    # process
    case  "$TT_cmd_choice" in
    1) 
        clear
        source table/showdataTB.sh 2> /dev/null
        ;;

    2)
        clear
        source table/insertrowTB.sh 2> /dev/null
        ;;

    3)
        clear
        source table/updatecellTB.sh 2> /dev/null
        ;;


    4)  clear
        source export2csv.sh 2> /dev/null
        ;;

    5)
        clear
        source table/rmrowTB.sh 2> /dev/null
        ;;

    6)
        clear
        echo "Table <$tb_name> DISCONNECTED "
        break;;

    *)
        clear
        echo -e "${BOLD_RED}Error: Invalid choice."
        echo -e "${NC}Please select a valid option."
        ;;
    esac
done
