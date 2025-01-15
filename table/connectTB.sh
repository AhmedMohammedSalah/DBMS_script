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
echo "enter your choice: "
read Tconnect_choice

# LOOP UNTIL GET RIGHT CHOICE
while [[ $Tconnect_choice -le 0 ||  $Tconnect_choice -gt $Tcounter ]]; do
    echo -e "${RED}Wrong choice!"
    echo -e "${WHITE}enter your choice: "
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
    echo -e "${BOLD_BLUE}4.${NC} ${RED}Remove Row${NC}"
    echo -e "${BOLD_BLUE}5.${NC} ${RED}TB $tb_name DISCONNECT${NC}"
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
        source table/showdataTB.sh;;

    2)
        clear
        source table/insertrowTB.sh;;

    3)
        clear
        source table/updatecellTB.sh;;

    4)
        clear
        source table/rmrowTB.sh;;

    5)
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

