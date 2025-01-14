#!/bin/bash
#       Logic
# change dir to  $1 ->cd
# check  permissions
# output connected succes --> list tables ->
# alternative
source ./var.sh

# Check if there are any databases available
if [ ! "$(ls -A "$MainDIR")" ]; then
    echo -e "\e[31mNo databases available to connect.\e[0m"
    exit 1
fi

# List all databases
echo -e "\e[36mAvailable Databases:\e[0m"
databases=()
counter=1
for db in "$MainDIR"/*/; do
    db_name=$(basename "$db")
    databases+=("$db_name")
    echo -e "\e[33m$counter.\e[0m \e[32m$db_name\e[0m"
    ((counter++))
done

# Prompt user to select a database
echo -e "\e[35mEnter the number of the database to connect to:\e[0m"
read -rp "Your choice: " choice

# Validate the user input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#databases[@]}" ]; then
    echo -e "\e[31mInvalid choice. Please run the script again and select a valid number.\e[0m"
    exit 1
fi

# Get the selected database name
selected_db="${databases[$((choice - 1))]}"
db_path="$MainDIR/$selected_db"

# Check permissions
./tools/checkPermissions.sh "$db_path"

# Connect to the selected database
if cd "$db_path" 2>/dev/null; then
    echo -e "\e[32mConnected to database '$selected_db' successfully.\e[0m"
    echo -e "\e[36mListing tables in the database:\e[0m"

    if [ "$(ls  .)" ]; then
        echo -e "\e[31mNo tables found in the database.\e[0m"
    fi
    db_name="$selected_db"
    
    
else
    echo -e "\e[31mError: Could not connect to the database. Please check permissions or directory existence.\e[0m"
    exit 1
fi
