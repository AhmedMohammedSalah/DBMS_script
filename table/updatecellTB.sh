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
#source ./var.sh [INTEGRATED >> db.sh]

# Variables
table=$current_TB_path                #[SENU] OLD =>"$current_DB_path/$tb_name"
metadatafile=$current_meta_TB_path    #[SENU] OLD =>"$current_DB_path/.$tb_name"

# Ensure table and metadata exist
if [ ! -f "$table" ]; then
    echo -e "${BOLD_RED}Error:${NC} Table '${BOLD_YELLOW}tb_name${NC}' does not exist."
    exit 1
fi

if [ ! -f "$metadatafile" ]; then
    echo -e "${BOLD_RED}Error:${NC} Metadata file for table '${BOLD_YELLOW}tb_name${NC}' not found."
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
            current_value=$(awk -v pk="$pk" -F: -v field_num=$((i + 1)) 'tb_name == pk {print $field_num}' "$table")
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
                if (tb_name == pk) {
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
        if grep -q "^$pk:" "$table"; then
            echo -e "${BOLD_MAGENTA}Available fields and types:${NC}"
            for i in "${!fields[@]}"; do
                echo -e "${BOLD_YELLOW}$((i + 1)).${NC} ${fields[i]} (Type: ${types[i]})"
            done

            while true; do
                read -rp "Enter the column number and new value (e.g., 2=new-value or press Enter to finish): " update
                if [[ -z "$update" ]]; then
                    break
                fi

                # Split the input into field number and new value
                IFS='=' read -r field_num new_value <<<"$update"

                if [[ -z "$field_num" || -z "$new_value" ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Invalid input. Please use the format 'field_number=new_value'."
                    continue
                fi

                # Adjust field number to match array index (1-based to 0-based)
                field_index=$((field_num - 1))

                if [[ "$field_index" -lt 0 || "$field_index" -ge "${#fields[@]}" ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Invalid field number."
                    continue
                fi

                # Validate input based on the field type
                if [[ "${types[field_index]}" == "INT" && ! "$new_value" =~ ^[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be an integer."
                elif [[ "${types[field_index]}" == "STR" && (-z "$new_value" || ! "$new_value" =~ ^[a-zA-Z[:space:]]+$) ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a non-empty string containing only letters and spaces."
                else
                    # Apply the update to the table
                    awk -v pk="$pk" -v field_num="$field_num" -v new_value="$new_value" -v FS=":" -v OFS=":" '{
                    if (tb_name == pk) {
                        $field_num = new_value;
                    }
                    print $0;
                }' "$table" >"$table.tmp" && mv "$table.tmp" "$table"
                    echo -e "${BOLD_GREEN}Field ${fields[field_index]} updated successfully.${NC}"
                fi
            done
            echo -e "${BOLD_GREEN}Updates completed.${NC}"
            
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
