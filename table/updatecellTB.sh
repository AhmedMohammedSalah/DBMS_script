#!/bin/bash
#               Logic
# update all columns
#     string new-name ,new-age
#     show data (pk)
#     update all new-name=user-enterd ,new-age=user-entere
# update specific ex.age new-name=old-name ,new-age=user-entered
# delete row (pk)
# insert pk new-name new-age
#     1 : ahmed :25
#     delete row
#     insert row pk =1 name =ahmed age=$age
#     1:kamal:23
# check permissions ,check exisits pk :cat | grep pk
#
# output 1 row affected
# alternative

# Load global variables
source ../var.sh

# Variables
table="$current_DB_path/$1"
metadatafile="$current_DB_path/.$1"

# Ensure table and metadata exist
if [ ! -f "$table" ]; then
    echo -e "${BOLD_RED}Error:${NC} Table '${BOLD_YELLOW}$1${NC}' does not exist."
    exit 1
fi

if [ ! -f "$metadatafile" ]; then
    echo -e "${BOLD_RED}Error:${NC} Metadata file for table '${BOLD_YELLOW}$1${NC}' not found."
    exit 1
fi

# Read fields from metadata
fields=()
types=()
while IFS=: read -r first_field field_type _; do
    fields+=("$first_field")
    types+=("$field_type")

done <"$metadatafile"

numoffields=${#fields[@]} # Total fields count

# Check permissions

# Menu for update options
while true; do
    echo -e "\n${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "${BOLD_CYAN}Select an option:${NC}"
    echo -e "  ${BOLD_BLUE}1.${NC} ${GREEN}Update all columns for a specific PK ${NC}"
    echo -e "  ${BOLD_BLUE}2.${NC} ${GREEN}Update specific columns for a specific PK ${NC}"
    echo -e "  ${BOLD_BLUE}3.${NC} ${RED}Exit ${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
    read -rp "Enter your choice: " choice

    case $choice in
    1)
        read -rp "Enter the primary key to update: " pk
        echo -e "${BOLD_GREEN}Table fields and types:${BOLD_YELLOW}"
        for i in "${!fields[@]}"; do
            echo -e "${BOLD_CYAN}Field: ${fields[i]}${NC}, Type: ${types[i]}"
        done
        echo -e "${BOLD_GREEN}Enter the new values for each field:${NC}"
        new_values_array=()
        for i in "${!fields[@]}"; do
            current_value=$(awk -v pk="$pk" -F: -v field_num=$((i + 1)) '$1 == pk {print $field_num}' "$table")
            echo -e "For field '${fields[i]}' (Type: ${types[i]}), current value is '${current_value}'"
            while true; do
                read -rp "Enter new value for '${fields[i]}': " new_value

                # Validate input based on the field type
                if [[ "${types[i]}" == "INT" && ! "$new_value" =~ ^[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be an integer."
                elif [[ "${types[i]}" == "STR" && (-z "$new_value" || ! "$new_value" =~ ^[a-zA-Z]+$) ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a non-empty string containing only letters and spaces."
                else
                    new_values_array+=("$new_value")
                    break
                fi
            done
        done

        # Check if pk exists
        if grep -q "^$pk:" "$table"; then
            # Update the table
            awk -v pk="$pk" -v new_values="${new_values_array[*]}" -v FS=":" -v OFS=":" '{
                if ($1 == pk) {
                    split(new_values, nv, " ");
                    for (i = 1; i <= length(nv); i++) {
                        $i = nv[i];
                    }
                }
                print $0;
            }' "$table" >"$table.tmp" && mv "$table.tmp" "$table"
            echo -e "${BOLD_GREEN}1 row affected.${NC}"
        else
            echo -e "${BOLD_RED}Error:${NC} PK '$pk' not found."
        fi
        ;;

    2)
        read -rp "Enter the primary key to update: " pk
        echo -e "${BOLD_MAGENTA}Available fields and types:${NC}"
        for i in "${!fields[@]}"; do
            echo -e "${BOLD_YELLOW}$((i + 1)).${NC} ${fields[i]} (Type: ${types[i]})"
        done
        read -rp "Enter the column numbers and new values (e.g., 2=new-age,3=new-city): " updates

        if grep -q "^$pk:" "$table"; then
            # Validate and apply updates
            awk -v pk="$pk" -v updates="$updates" -v FS=":" -v OFS=":" '{
                if ($1 == pk) {
                    split(updates, u, ",");
                    for (i in u) {
                        split(u[i], pair, "=");
                        field_num=pair[1];
                        new_value=pair[2];
                        # Check field type (e.g., INT)
                        if (field_num == 2 && !new_value ~ /^[0-9]+$/) {
                            print "Error: Value for field " field_num " must be an integer!";
                            next;
                        }
                        $field_num = new_value;
                    }
                }
                print $0;
            }' "$table" >"$table.tmp" && mv "$table.tmp" "$table"
            echo -e "${BOLD_GREEN}1 row affected.${NC}"
        else
            echo -e "${BOLD_RED}Error:${NC} PK '$pk' not found."
        fi
        ;;
    3) # Exit
        echo -e "${BOLD_RED}Exiting...${NC}"
        break
        ;;

    *)
        echo -e "${BOLD_RED}Error:${NC} Invalid choice. Please select a valid option."
        ;;
    esac

done
