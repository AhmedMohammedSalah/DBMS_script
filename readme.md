database operations like 
creating, Done 
listing, Done 
connecting to  Done 
deleting databases,Done 
Instructions: 
1. General Requirements: 
Write all scripts using Bash scripting.
Use clear and user-friendly prompts for interaction. 
Follow modular programming principles:
A main script (db.sh) to handle database-level operations. Done  
A separate script (table.sh) to handle table-level operations.Done 
Create Database: <done> 
        Prompt the user to enter a name for the database. 
        Validate the name to avoid special characters or numbers at the start. 
        Create a folder for the database and ensure appropriate permissions. 
List Databases:<done> 
        Display all available databases in the system. 
Connect to Database:<done> 
        Allow the user to connect to an existing database. 
        Once connected, transfer control to the table.sh script for table operations. 
Delete Database:<done> 
        Prompt the user for confirmation before deletion. 
        Ensure the database exists before attempting deletion. 
Exit: 
Provide an option to exit the program gracefully. 
 
Table Management (table.sh): 
 
    Create Table: <done>
        Allow users to define a table name and the number of columns. 
        Prompt users to specify column names and their data types (e.g., Integer, String). 
        Create a metadata file to store table structure. --> hidden file
        
    List Tables: <done>
        Display all available tables in the connected database.
        
    Drop Table: <done>
        Allow users to delete a table after confirmation. 
    
    Insert Row: <done> 
        Validate and insert data into the table. Ensure primary keys are unique.
        
    Show Data: <done> 
        Display table data with an option to select all or specific columns. 
        
    Delete Row: <done>
        Allow users to delete specific rows based on a unique identifier. 

    Update Cell: <done>
        Enable users to update specific cells in the table by row and column numbers.
        string new-name ,new-age 
        show data (pk)
        update all new-name=user-enterd ,new-age=user-entere
	update specific ex.age new-name=old-name ,new-age=user-entered 
	delete row (pk)
	insert pk new-name new-age
        1 : ahmed :25
        delete row 
        insert row pk =1 name =ahmed age=$age  
        1:kamal:23

    Exit: 
        Return control to the main menu (db.sh). 
 
Bonus: 
Offer extra credit for additional features like: 

    Searching for data within a table.  
    Exporting table data to a CSV file. Task Search 
    
    ├── connectDB.sh
	├── createDB.sh 1 x
	├── db.sh end
	├── delDB.sh 4 x
	├── listDBs.sh 1 x
	├── table
	│   ├── createTB.sh 9.5 x  <FINISHED>
	│   ├── delrowTB.sh  7 x
	│   ├── dropTB.sh  4 x
	│   ├── insertrowTB.sh 8x
	│   ├── listTB.sh  1 x     <FINISHED>
	│   ├── showdataTB.sh   9 x
	│   └── updatecellTB.sh  8.5
	└── table.sh
    salah h -> e
    kamal e -> h
    table implemention more hard than DB 
    10/1 -> study awk - sed createDB.sh S+createTB.sh 9.5 K
    11/1 -> listDBs.sh 1 +listTB.sh  1  +
        dropTB.sh  4 S
    12/1 ->delDB.sh 4 + delrowTB.sh  7
    13/1 ->insertrowTB.sh 8+showdataTB.sh   9
    14/1 -> updatecellTB.sh  8.5 +refresh
    15/1 >>free to study for exam 
    16/1 >> 
    