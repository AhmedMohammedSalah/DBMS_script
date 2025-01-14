#!/bin/bash

# source /home/$USER/GIT_SHARE/DBMS_script/var.sh
# source /home/$USER/GIT_SHARE/DBMS_script/tools/tools_RRTB.sh

source ../var.sh
source ../tools/tools_RRTB.sh

#[PROCSS] GET THE FIELD NAME WITH THE PK
pk_name=$(grep ":PK" "$current_meta_TB_path" | cut -d ':' -f 1)


# <VIEW PK>
echo -e "${WHITE}PK COLUMN: $pk_name"

#[ENTER] INPUT (SUPPOSED TO BE IN THE TABLE)
echo -e "${GRAY}>> REMOVE ROW BY UNIQUE INDENTIFIER (PK) >>${WHITE}"
read -p '> ' input


# will take its vales from [search_value_in_pk] function
searched_line_no=""
searched_line=""

#[PROCESS] SEARCH THE VALUE ON THE PK COLUMN IN THE TABLE
search_value_in_pk "$pk_name" "$input" searched_line_no searched_line

if [ ! -z "$searched_line" ]; then

    # remove line
    sed -i "${searched_line_no}d" "$current_TB_path"

    # feedback
    echo -e "${GREEN}line removed: $searched_line"
    echo -e "${GREEN}line removed Succesfully"
fi


