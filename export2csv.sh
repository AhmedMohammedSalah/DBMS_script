#!/bin/bash

export_path="/home/$USER/Documents/DBMS_EXPORTS"

# directory creation in documents dir in home
mkdir -p "$export_path"

# exported file path
exported_file_path="$export_path/$tb_name.csv"

# convert and write
awk '{gsub(/:/, ", "); print}' "$current_TB_path" >"$exported_file_path" 2>/dev/null

# feedback
echo -e "${GRAY}saving in: home/Documents/DBMS_EXPORTs "
echo -e "${GREEN}✔✔ Succesfully exported"
