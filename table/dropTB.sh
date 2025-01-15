#!/bin/bash
#               Logic
# ./listTB
# remove the $tb_name choice  table
# check  permissions,confirmation
# output table deleted successfully /n ./listTB
# alternative
# before call this file :-
# list all dbs
# let user add the num of desired DB
# pass the name of desired DB to this file
#-----------------------------------------------------



#-------------SENU-ALTER-BEGIN----------------------------------

# <LOGIC ADDED>
# need to update current_TB_path based on the choice
# and at the end reset the current_TB_path



source ./table/listTB.sh
# table_lst : get name based choice as index.
# Tcounter  : check range of choices.


# [ENTER]
echo -e "${WHITE}Enter your choice"
read -p '> ' drop_choice

# LOOP UNTIL GET RIGHT CHOICE
while [[ $drop_choice -le 0 ||  $drop_choice -gt $Tcounter ]]; do
    echo -e "${RED}Wrong choice!"
    echo -e "${WHITE}enter your choice: "
    read -p '> ' drop_choice
done

# to be used as index [zero-based]
((drop_choice--))


#updating
tb_name="${table_lst[$drop_choice]}"
current_TB_path="$MainDIR/$db_name/$tb_name"
current_meta_TB_path="$MainDIR/$db_name/.$tb_name" #dot


#--------------SENU-ALTER-END----------------------------------

# [CHECK]  table exists ?
if [ -f "$current_TB_path" ]; then 

    # check permission
    ./tools/checkPermissions.sh $current_TB_path

    # [ENTER]
    echo -e "${BOLD_BLUE}Are you sure you want to ${YELLOW}DELETE '$tb_name' table${BOLD_BLUE}? (y/n):${NC}"
    read -p '> ' choice

    # [YES CHOICE PORCESS]
    if [[ $choice == "y"  || $choice == "Y" ]]; then

        # [REMOVE]: file, meta
        rm "$current_TB_path"
        rm "$current_meta_TB_path"

        # <FEEDBACK>
        clear #<-----[SENU ALTER]
        echo -e "\e[33mTable $tb_name deleted successfully.\e[0m"

    
    # [NO CHOICE PORCESS]
    elif [[ $choice == "n"  ||  $choice == "N" ]]; then

        # <FEEDBACK>
        clear #<-----[SENU ALTER]
        echo -e "${YELLOW}Operation Cancelled"

        #[SENU ALTER]: too long
        #-----------------------------------------------------
        #echo -e "${GRAY}NOTE: Table <$tb_name> still exists."
        #-----------------------------------------------------
        echo -e "${GRAY}Return to menu..."
    
    # [not Y nor N]
    else
        clear #<----[SENU ALTER]
        echo -e "${YELLOW}Unknown choice."
        echo -e "${GRAY}Return to menu..."
    fi

#[cont.CHECK] if table not exist
else
    echo -e "${RED}Table <$tb_name> does not exist.${WHITE}"
fi


tb_name=""
current_TB_path=""
current_meta_TB_path="" #dot