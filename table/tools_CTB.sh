#GLOBAL VARIABLES
declare -gA dic_fields # to store: field name : [dtype, constraint]


# FUNC: CHECK EMPTY INPUT NAME ?
function check_empty
{
    declare -n ref=$1 
    msg=$2

    while [ -z "$ref" ]; do
        echo "Input cannot be empty."
        echo "$msg"
        read new_var  
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
        echo "Invalid input, enter string, please:"
        read name
        ref=$name
    done
}

function check_exist 
{

    declare -n ref=$1
    while [ -f "$current_DB_path/$ref" ]; do

        echo "Table name already exists. Enter a different table name:"
        read name

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
        echo "More than 20 fields, are you sure? (y/n)"

        # CONTINUE ?
        read choice

        if [ "$choice" == "n" ]; then
            # [ENTER]
            echo "Enter number of fields again:"
            read num

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
        echo "Invalid input, enter an integer, please:"
        read number
        ref=$number
    done
}


# FUNC: CHECK NEGATIVE NUM
function check_negative
{
    declare -n ref=$1

    while [ "$ref" -lt 0 ]; do
        echo "Invalid number"
        echo "enter again, please:"
        read number

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
        echo "already exist, enter name again:"
        read field_name
        ref=$field_name
    done
}

# FUNC: GET DTYPE BASED CHOICE
function add_dtype
{

    declare -n ref=$1
    # :-> inifinte loop
    while :; do
        echo "Enter Dtype for $field:"
        echo "1-STRING | 2-INTEGER | 3-FLOAT"
        read choice
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
        echo "Enter constraint for $field:"
        echo "1-PK | 2-NOTNULL | 3-UNIQUE | 4-FK"
        read choice
        case $choice in
            1)  
                # [CHECK] ONLY ONE PK
                if ! PK_condition; then
                    echo "PK already exist"
                    continue 
                fi

                ref="PK"; break;;

            2)  ref="NOTNULL"; break ;;
            3)  ref="UNIQUE";  break ;;
            4)  ref="FK";      break ;;
            *) echo "Invalid choice." ;;
        esac
    done

}
