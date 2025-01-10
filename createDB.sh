#!/bin/bash
#       Logic
# create folder from $1 ->mkdir
# check name permissions repeated
# output db created seccesful
# alternative

source ./var.sh

./tools/checkPermissions.sh #$MainDIR

while true; do
    read -p "Enter the name of the database (or type 'exit' to quit): " dbname

    # Check if input is empty
    if [[ -z "$dbname" ]]; then
        echo "Database name cannot be empty. Please try again."
    elif [[ "$dbname" == "exit" ]]; then
        echo "Exiting..."
        break
    else
        mkdir -p "$MainDIR/$dbname"
        # -p option to create parent directories if they don't exist
        echo -e "\e[32mDatabase '$dbname' created successfully\e[0m"
        break
    fi
done

# coloring terminal
# Explanation of the Colors:
# Escape Code Syntax:

# \e[<code>m: Starts the escape sequence.
# <code> specifies the color or style.
# \e[0m: Resets the color to default.
# Common Color Codes:

# \e[31m: Red
# \e[32m: Green
# \e[33m: Yellow
# \e[34m: Blue
# \e[35m: Magenta
# \e[36m: Cyan
# \e[0m: Reset (default color)
# Text Appearance in the Script:

# Red for errors: \e[31m
# Yellow for warnings or exits: \e[33m
# Green for success: \e[32m
