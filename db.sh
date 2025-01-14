# #!bin/zsh
# #       Logic
# # 
# # output:-infinity loop of choices
# # alternative

# # 
# #   Create Database:List Databases:Connect to Database:Delete Database:Exit:

# echo "Welcom ${USER} in our system "
# while true; do
#     echo -e "\n${BOLD_GRAY}------------------------------------------${NC}"
#     echo -e "${BOLD_CYAN}Select an option:${NC}"
#     echo -e "  ${BOLD_BLUE}1.${NC} ${GREEN}List all data from the table${NC}"
#     echo -e "  ${BOLD_BLUE}2.${NC} ${GREEN}Select data based on field=value${NC}"
#     echo -e "  ${BOLD_BLUE}3.${NC} ${RED}Exit${NC}"
#     echo -e "${BOLD_GRAY}------------------------------------------${NC}"
#     read -rp "Enter your choice: " choice
#     case $choice in
#     1)

# echo ""
# # list of choices
# # Create Database:
# # List Databases
# # :Connect to Database
# # :Delete Database
# # :Exit:

# INCLUDE
source /home/$USER/GIT_SHARE/DBMS_script/var.sh



while true; do

    echo -e "${WHITE}Enter your choice: "

    echo "1- Create DB"
    echo "2- Connect DB"
    echo "3- List DB"
    echo "4- Delete DB"
    echo "5- EXIT"

    read choice

    case choice in
    1) createDB;;
    2)  
        # [PROCES]: list
        listDB

        # [ENTER]
        echo "choose DB:"
        read connect_choice

        # [CHECK] CHOICE EXIST
        




    


done

