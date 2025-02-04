
# dic_fields declared in createTB


# FUNC: CHECK EMPTY INPUT NAME ?
function check_empty
{
    
    declare -n ref=$1 
    msg=$2

    while [ -z "$ref" ]; do
        echo -e "${RED}Input cannot be empty."
        echo -e "${BOLD_BLUE}$msg${NC}"
        read -p "> " new_var  
        ref=$new_var 
    done
}


# FUNC: CHECK STRING

#1
str_condition() 
{
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then 
        return 0  # TRUE
    else 
        return 1  # FALSE
    fi
}

#2
function check_string
{
    declare -n ref=$1

    while ! str_condition "$ref"; do
        echo -e "${RED}Invalid input," 
        echo -e "${BOLD_BLUE}Enter String, please:${NC}"
        read -p "> " name
        ref=$name
    done
}

function check_exist 
{

    declare -n ref=$1

    while [ -f "$current_DB_path/$ref" ]; do
        echo -e "${RED}Table \"${ref}\" already exists"
        echo -e "${BOLD_BLUE}Enter Different Table Name:${NC}"
        read -p "> " name

        # [CHECK] EMPTY, STRING
        check_empty name "Enter Table Name:"
        check_string name

        ref=$name

    done
}


function warn_big_input
{

    declare -n ref=$1

    if [ "$ref" -gt 20 ]; then
        echo -e "${BOLD_BLUE}More than 20 fields, are you sure? (y/n)${NC}"

        # CONTINUE ?
        read -p "> " choice

        if [ "$choice" == "n" ]; then
            # [ENTER]
            echo -e "${BOLD_BLUE}Enter number of fields again:${NC}"
            read -p "> " num

            # [CHECKs]
            check_empty num "Enter number of fields:"
            check_integer num
            check_negative num

            ref=$num
        fi
    fi
}



# FUNC: CHECK INTEGER

#1
int_condition() 
{
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        return 0  # TRUE
    else
        return 1  # FALSE
    fi
}

#2
function check_integer
{
    declare -n ref=$1
    while ! int_condition "$ref"; do
        echo -e "${RED}Invalid input."
        echo -e "${BOLD_BLUE}Enter Integer, please:${NC}"
        read -p "> " number
        ref=$number
    done
}


# FUNC: CHECK NEGATIVE NUM
function check_negative
{
    declare -n ref=$1

    while [ "$ref" -lt 0 ]; do
        echo -e "${RED}Invalid number"
        echo -e "${BOLD_BLUE}enter again, please:${NC}"
        read -p "> " number

        # [CHECK] EMPTY INPUT ?
        check_empty number "Enter number of fields:"

        # [CHECK] INTEGER ?
        check_integer number

        ref=$number  

    done

}

#FUNC: CHECK FIELD ENTERED BEFORE
function field_exist_condition
{
    entered_field=$1
    for key in "${!dic_fields[@]}"; do
        if [[ "$key" == "$entered_field" ]]; then
            return 1
        fi
    done
    return 0
}


function check_field_exist
{
    declare -n ref=$1
    while ! field_exist_condition "$ref"; do
        echo -e "${RED}already exist"
        echo -e "${BOLD_BLUE}enter name again:${NC}"
        read -p "> " field_name
        ref=$field_name
    done
}

# FUNC: GET DTYPE BASED CHOICE
function add_dtype
{

    declare -n ref=$1
    # :-> inifinte loop
    while :; do
        echo -e "${BOLD_BLUE}Enter Dtype for $field:"
        echo -e "${MAGENTA}1-STRING | 2-INTEGER | 3-FLOAT ${NC}"
        read -p "> " choice
        case $choice in
            1) ref="STR"; break ;;
            2) ref="INT"; break ;;
            3) ref="FLOAT"; break ;;
            *) echo "Invalid choice.";;
        esac
    done

}

# 4- table can't have two primary key
# 5- if the user want to make composite primary key
#    this will be alteration on the table not related to creation

# FUNC: CHECK PK EXIST

function PK_condition {
    
    for value in "${dic_fields[@]}"; do

        # [PROCESS] extract the constraint
        constraint=$(echo "$value" | cut -d':' -f2)
        if [[ "$constraint" == "PK" ]]; then
            return 1  # PK FOUND!
        fi
    done
    return 0  # NO ANTOTHER PK
}


function add_constraint 
{

    declare -n ref=$1
    # :-> inifinte loop
    while :; do
        echo -e "${BOLD_BLUE}Enter constraint for $field:"
        echo -e "${MAGENTA}1-PK | 2-NOTNULL | 3-UNIQUE | 4-NULL${NC}"
        read -p "> " choice
        case $choice in
            1)  
                # [CHECK] ONLY ONE PK
                if ! PK_condition; then
                    echo -e "${RED}PK already exist${NC}"
                    continue 
                fi

                ref="PK"; break;;

            2)  ref="NOTNULL"; break ;;
            3)  ref="UNIQUE";  break ;;
            4)  ref="NULL";    break ;;
            *) echo "Invalid choice." ;;
        esac
    done

}


#[CHECK] PRIMARY KEY EXISTENCE

function list_fields 
{
    counter=1
    for key in "${!dic_fields[@]}"; do
        echo -e "${WHITE}$counter- $key"
        ((counter++))
    done
}

function get_field_name 
{

    local choice=$1
    declare -n ref=$2
    local counter=1

    for key in "${!dic_fields[@]}"; do
        if [[ "$choice" -eq "$counter" ]]; then
            ref=$key
            break
        fi
        ((counter++))
    done

    # <ERROR FEEDBACK>
    if [[ -z $ref ]]; then
        echo -e "${RED}Invalid choice."
    fi
}

function add_single_pk 
{
    
    chosed_field=""

    while [[ -z "$chosed_field" ]]; do
        # [OUTPUT]
        list_fields

        # [ENTER]
        echo -e "${WHITE}Enter your choice:"
        read -p "> " choice

        # [CHECK] EMPTY, INTEGER
        check_empty choice "Enter yout choice:"
        check_integer choice

        # [PROCESS] Get field name based on choice
        get_field_name "$choice" chosed_field
    done

    # Now field name is supposed to be retrieved

    # [PROCESS]: Change constraint for the field in the dictionary
    chosed_field_dtype=${dic_fields[$chosed_field]%%:*}
    dic_fields[$chosed_field]="$chosed_field_dtype:PK"

    echo -e "${WHITE}After alteration: ${dic_fields[$chosed_field]}"
}

function PK_handle {
    if PK_condition; then
        echo -e "${RED}Table must have PK"
        add_single_pk
    fi
}






