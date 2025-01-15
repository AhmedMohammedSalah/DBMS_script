#!/bin/bash
# Script: deleteDB.sh
# Purpose: List all databases, let the user select a database by number, and delete it.

# Load global variables
source ./var.sh

# Check if there are any databases available
if [ ! "$(ls -A "$MainDIR")" ]; then
    echo -e "\e[31mNo databases available to delete.\e[0m"
    exit 1
fi

# Function to handle the database selection and deletion
delete_database() {
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
    echo -e "\e[35mEnter the number of the database to delete:\e[0m"
    read -rp "Your choice: " choice

    # Validate the user input
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#databases[@]}" ]; then
        clear
        echo -e "\e[31mInvalid choice. Please enter a valid number.\e[0m"
    
        delete_database  
        return
    fi

    # Get the selected database name
    selected_db="${databases[$((choice - 1))]}"
    db_path="$MainDIR/$selected_db"

    # Check permissions
    ./tools/checkPermissions.sh "$db_path"

    # Confirm deletion
    read -p "Are you sure you want to delete the database '$selected_db'? (y/n): " confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        # Attempt to delete the database
        if rmdir "$db_path" 2>/dev/null || rm -r "$db_path"; then
            echo -e "\e[32mDatabase '$selected_db' deleted successfully.\e[0m"
        else
            echo -e "\e[31mError: Could not delete the database. Please check permissions or directory contents.\e[0m"
        fi
    elif [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        echo -e "\e[33mOperation canceled. Database '$selected_db' still exists.\e[0m"
    else
        echo -e "\e[35mUnknown choice. Operation aborted.\e[0m"
    fi
}

# Call the main function
delete_database
