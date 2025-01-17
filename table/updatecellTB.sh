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
table=$current_TB_path             #[SENU] OLD =>"$current_DB_path/$tb_name"
metadatafile=$current_meta_TB_path #[SENU] OLD =>"$current_DB_path/.$tb_name"

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
constraints=()

while IFS=: read -r first_field field_type constraint_t; do
    fields+=("$first_field")
    types+=("$field_type")
    constraints+=("$constraint_t")
done <"$metadatafile"

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

        # Display table fields and types
        echo -e "${BOLD_GREEN}Table fields and types:${BOLD_YELLOW}"
        for i in "${!fields[@]}"; do
            echo -e "${BOLD_CYAN}Field: ${fields[i]}${NC}, Type: ${types[i]}, Constraint: ${constraints[i]}"
        done

        echo -e "${BOLD_GREEN}Enter the new values for each field:${NC}"
        new_values_array=()

        # Determine the index of the primary key column
        pk_index=-1
        for i in "${!constraints[@]}"; do
            echo "${constraints[i]}"
            if [[ "${constraints[i]}" == "PK" ]]; then
                pk_index=$i
                break
            fi
        done

        if [[ "$pk_index" -eq -1 ]]; then
            echo -e "${BOLD_RED}Error:${NC} No primary key defined in metadata."
            return
        fi

        # Process each field
        for i in "${!fields[@]}"; do
            current_value=$(awk -v pk="$pk" -v field_num=$((i + 1)) -F: '$1 == pk {print $field_num}' "$table")
            echo -e "For field '${fields[i]}' (Type: ${types[i]}, Constraint: ${constraints[i]}), current value is '${current_value}'"

            while true; do
                read -rp "Enter new value for '${fields[i]}': " new_value

                # Validate input based on field type and constraints
                if [[ "${types[i]}" == "INT" && ! "$new_value" =~ ^[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be an integer."
                elif [[ "${types[i]}" == "FLOAT" && ! "$new_value" =~ ^[+-]?[0-9]*\.?[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a float (e.g., 123, -123.45, or 0.5)."
                elif [[ "${types[i]}" == "STR" && (-z "$new_value" || ! "$new_value" =~ ^[a-zA-Z[:space:]]+$) ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a non-empty string containing only letters and spaces."
                elif [[ "${constraints[i]}" == "NOTNULL" && -z "$new_value" ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value cannot be NULL."
                elif [[ "${constraints[i]}" == "UNIQUE" && $(
                    cut -d: -f$((i + 1)) "$table" | grep -xq "$new_value"
                    echo $?
                ) -eq 0 ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be unique."
                elif [[ "$i" -eq "$pk_index" && "$new_value" != "$current_value" ]]; then
                    # Check if the new primary key value is unique
                    if grep -v "^$pk:" "$table" | cut -d: -f$((pk_index + 1)) | grep -xq "$new_value"; then
                        echo -e "${BOLD_RED}Error:${NC} Primary key must be unique. Value '$new_value' is already used."
                        break # Exiting the loop for this field, retrying the primary key
                    fi
                else
                    new_values_array+=("$new_value")
                    break # Proceeding to the next field after valid input
                fi
            done
        done

        # Check if the primary key exists in the table
        if grep -q "^$pk:" "$table"; then
            # Update the table
            awk -v pk="$pk" -v pk_index=$((pk_index + 1)) -v new_values="${new_values_array[*]}" -v FS=":" -v OFS=":" '{
                if ($pk_index == pk) {
                    # Split new values into an array
                    split(new_values, nv, " ");
                    # Update each field with the new value
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

        # Check if the primary key exists in the table
        if grep -q "^$pk:" "$table"; then
            echo -e "${BOLD_MAGENTA}Available fields, types, and constraints:${NC}"
            for i in "${!fields[@]}"; do
                echo -e "${BOLD_YELLOW}$((i + 1)).${NC} ${fields[i]} (Type: ${types[i]}, Constraint: ${constraints[i]})"
            done

            # Find the index of the primary key column
            pk_index=-1
            for i in "${!constraints[@]}"; do
                if [[ "${constraints[i]}" == "PK" ]]; then
                    pk_index=$i
                    break
                fi
            done

            if [[ "$pk_index" -eq -1 ]]; then
                echo -e "${BOLD_RED}Error:${NC} No primary key defined in metadata."
                exit 1
            fi

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

                # Validate input based on the field type and constraints
                if [[ "${types[field_index]}" == "INT" && ! "$new_value" =~ ^[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be an integer."
                elif [[ "${types[field_index]}" == "FLOAT" && ! "$new_value" =~ ^[+-]?[0-9]*\.?[0-9]+$ ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a float."
                elif [[ "${types[field_index]}" == "STR" && (-z "$new_value" || ! "$new_value" =~ ^[a-zA-Z[:space:]]+$) ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be a non-empty string containing only letters and spaces."
                elif [[ "${constraints[field_index]}" == "NOTNULL" && -z "$new_value" ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value cannot be NULL."
                elif [[ "${constraints[field_index]}" == "UNIQUE" && $(
                    cut -d: -f$((field_index + 1)) "$table" | grep -xq "$new_value"
                    echo $?
                ) -eq 0 ]]; then
                    echo -e "${BOLD_RED}Error:${NC} Value must be unique."
                elif [[ "$field_index" -eq "$pk_index" ]]; then
                    # Check if the new primary key is unique (excluding the current record)
                    if grep -v "^$pk:" "$table" | cut -d: -f$((pk_index + 1)) | grep -xq "$new_value"; then
                        echo -e "${BOLD_RED}Error:${NC} Primary key must be unique. Value '$new_value' is already used."
                    else
                        # Apply the update to the table
                        awk -v pk="$pk" -v pk_index=$((pk_index + 1)) -v field_num=$((field_index + 1)) -v new_value="$new_value" -v FS=":" -v OFS=":" '{
                        if ($pk_index == pk) {
                            $field_num = new_value;
                        }
                        print $0;
                    }' "$table" >"$table.tmp" && mv "$table.tmp" "$table"
                        echo -e "${BOLD_GREEN}Primary key updated successfully.${NC}"
                    fi
                else
                    # Apply the update to the table
                    awk -v pk="$pk" -v pk_index=$((pk_index + 1)) -v field_num=$((field_index + 1)) -v new_value="$new_value" -v FS=":" -v OFS=":" '{
                    if ($pk_index == pk) {
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
