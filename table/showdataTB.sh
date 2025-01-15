#!/bin/bash
# ./showdataTB.sh table name
#               Logic
# list data from table  -> cat table | advanced
# depands on specific fields
# <Bonus> depends on specific word (grep)
# <Bonus> depends on specific word (grep) and specific field (cut)
# check permissions
#
# output tables
# alternative -r
#------------------------------------------------------

# Load global variables
#source ./var.sh # [INTEGRATED >> db.sh]

# Variables
table=$current_TB_path                #[SENU] OLD =>"$current_DB_path/$tb_name"
metadatafile=$current_meta_TB_path    #[SENU] OLD =>"$current_DB_path/.$tb_name"

# Ensure metadata exists to determine number of fields
if [ ! -f "$metadatafile" ]; then
    echo -e "${BOLD_RED}Error:${NC} Metadata file for table '${BOLD_YELLOW}$tb_name${NC}' not found."
    exit 1
fi

# Read fields from metadata
fields=()
while IFS=: read -r first_field _; do
    fields+=("$first_field")
done <"$metadatafile"

numoffields=${#fields[@]} # Total fields count

# Check if table exists and is not empty
if [ ! -f "$table" ]; then
    echo -e "${BOLD_RED}Error:${NC} Table '${BOLD_YELLOW}$tb_name${NC}' does not exist."
    exit 1
fi

if [ "$(wc -l <"$table")" -le 1 ]; then
    echo -e "${BOLD_RED}Error:${NC} Table '${BOLD_YELLOW}$tb_name${NC}' is empty."
    exit 1
fi

# Display table details
echo -e "${BOLD_GREEN}Table '${BOLD_YELLOW}$tb_name${BOLD_GREEN}' contains ${BOLD_BLUE}$numoffields${BOLD_GREEN} fields:${NC}"
for i in "${!fields[@]}"; do
    echo -e "  ${BOLD_CYAN}Field $((i + 1)): ${BOLD_WHITE}${fields[i]}${NC}"
done

record_count=$(($(wc -l <"$table") - 1))
echo -e "${BOLD_YELLOW}Table '${BOLD_YELLOW}$tb_name${BOLD_YELLOW}' contains ${BOLD_BLUE}$record_count${BOLD_YELLOW} records.${NC}"

while true; do
    echo -e "\n${BOLD_GRAY}------------------------------------------${NC}"
    echo -e "${BOLD_CYAN}Select an option:${NC}"
    echo -e "  ${BOLD_BLUE}1.${NC} ${GREEN}List all data from the table${NC}"
    echo -e "  ${BOLD_BLUE}2.${NC} ${GREEN}Select data based on field=value${NC}"
    echo -e "  ${BOLD_BLUE}3.${NC} ${RED}Exit${NC}"
    echo -e "${BOLD_GRAY}------------------------------------------${NC}"
    read -rp "Enter your choice: " choice

    case $choice in
    1)
        echo -e "${BOLD_GREEN}Choose an option for displaying table data:${NC}"
        echo -e "  ${BOLD_BLUE}1.${NC} ${CYAN}Display all columns${NC}"
        echo -e "  ${BOLD_BLUE}2.${NC} ${CYAN}Display specific columns${NC}"
        read -rp "Enter your choice: " display_choice

    

        if [[ "$display_choice" == "1" ]]; then

            # FOR CLARITY
            clear #<----[SENU]

            # Display all columns
            awk -v fields="${fields[*]}" 'BEGIN {
                FS = ":";
                split(fields, f, " ");
            for (i in f) {
                    printf "\033[1;36m%-20s\033[0m", f[i];
                }
                print "";
                print str_repeat("-", 20 * length(f));
            }
            
            function str_repeat(char, count) {
                result = "";
                for (i = 1; i <= count; i++) {
                    result = result char;
                }
                return result;
            }
            NR > 1 {
                for (i = 1; i <= NF; i++) {
                    printf "%-20s", $i;
                }
                print "";
            }' "$table"

  

        elif [[ "$display_choice" == "2" ]]; then
            # Display specific columns
            echo -e "${BOLD_MAGENTA}Available fields:${NC}"
            for i in "${!fields[@]}"; do
                echo -e "${BOLD_YELLOW}$((i + 1)).${NC} ${fields[i]}"
            done
            read -rp "Enter column numbers to display (e.g., 1 3): " column_numbers

            # Validate column numbers
            valid=true
            for col in $column_numbers; do
                if ! [[ "$col" =~ ^[0-9]+$ ]] || [[ "$col" -lt 1 || "$col" -gt "$numoffields" ]]; then
                    valid=false
                    break
                fi
            done

            if [[ "$valid" == "true" ]]; then
                awk -v fields="${fields[*]}" -v columns="$column_numbers" 'BEGIN {
                        FS = ":";
                split(fields, f, " ");
            for (i in f) {
                    printf "\033[1;36m%-20s\033[0m", f[i];
                }
                print "";
                print str_repeat("-", 20 * length(f));
            }
            
            function str_repeat(char, count) {
                result = "";
                for (i = 1; i <= count; i++) {
                    result = result char;
                }
                return result;
            }
                NR > 1 {
                    for (i in cols) {
                        printf "%-20s", $cols[i];
                    }
                    print "";
                }' "$table"
            else
                echo -e "${BOLD_RED}Error:${NC} Invalid column numbers. Please try again."
            fi
        else
            echo -e "${BOLD_RED}Error:${NC} Invalid choice. Please try again."
        fi
        ;;

    2)
        echo -e "${BOLD_GREEN}Filter data based on a field and value:${NC}"
        echo -e "${BOLD_MAGENTA}Available fields:${NC}"
        for i in "${!fields[@]}"; do
            echo -e "${BOLD_YELLOW}$((i + 1)).${NC} ${fields[i]}"
        done

        read -rp "Enter the field number to filter by: " field_number
        if [[ "$field_number" -ge 1 && "$field_number" -le "$numoffields" ]]; then
            field_name="${fields[$((field_number - 1))]}"
            read -rp "Enter the value to match for $field_name: " value
            awk -v field_num="$field_number" -v filter_value="$value" -v fields="${fields[*]}" 'BEGIN {
                FS = ":";
                split(fields, f, " ");
            for (i in f) {
                    printf "\033[1;36m%-20s\033[0m", f[i];
                }
                print "";
                print str_repeat("-", 20 * length(f));
            }
            
            function str_repeat(char, count) {
                result = "";
                for (i = 1; i <= count; i++) {
                    result = result char;
                }
                return result;
            }
            NR > 1 && $field_num == filter_value {
                for (i = 1; i <= NF; i++) {
                    printf "%-20s", $i;
                }
                print "";
            }' "$table"
        else
            echo -e "${BOLD_RED}Error:${NC} Invalid field number. Please try again."
        fi
        ;;
    3)
        echo -e "${BOLD_RED}Exiting...${NC}"
        break
        ;;
    *)
        echo -e "${BOLD_RED}Error:${NC} Invalid choice. Please select a valid option."
        ;;
    esac
done
