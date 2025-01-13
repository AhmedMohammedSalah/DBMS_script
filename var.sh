# Main dir of all dbs 
MainDIR="/home/$USER/databases"

# Name of the current DB
db_name="school"

# Current DB path
current_DB_path="$MainDIR/$db_name"

# Name of current table
tb_name="student"

# Current Table path
current_TB_path="$current_DB_path/$tb_name"

# Current meta Table path
current_meta_TB_path="$current_DB_path/.$tb_name"


#for colors
GRAY='\033[1;30m'  # for more info before enter
GREEN='\033[0;32m' # for success
WHITE='\033[0;37m' # normal enter
RED='\033[0;31m'   #for error
BLUE='\033[4;34m'  # for asking (y\n)


