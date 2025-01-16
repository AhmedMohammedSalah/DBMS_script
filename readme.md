# Database Management System (DBMS) Project

## **Introduction**

This project is a lightweight Database Management System (DBMS) implemented using Bash scripting. It provides functionalities for managing databases and tables, such as creating, listing, connecting, and deleting them.

---

## **Features**

- Create and manage multiple databases.
- Perform table operations (create, list, delete, connect).
- Filter and display data based on specific fields or values.
- Interactive menu-driven interface.

---

## **Prerequisites**

Before setting up the project, ensure the following tools and permissions are available:

1. **Operating System:** Linux-based system (e.g., Ubuntu, Debian).
2. **Shell:** Bash shell.
3. **Permissions:** Root or sudo privileges to set up the project.

---

## **Installation Steps**

### **Step 1: Clone the Repository**

```bash
# Clone the repository
git clone <repository-url>

# Navigate to the project directory
cd <repository-folder>
```

### **Step 2: Run the Installer Script**

1. Execute the `install` script to set up the project:

   ```bash
   chmod +x install
   sudo ./install
   ```

2. The script will:

   - Create the installation directory (`/usr/bin/DBMA`).
   - Copy all project files to the directory.
   - Create a utility script (`doubleA`) to simplify DBMS access.

3. Once installation is complete, you'll see a success message:
   ```
   DBMS installed successfully!
   Usage: Type doubleA in the terminal to run the DBMS.
   ```

---

## **Usage Instructions**

### **Starting the DBMS**

1. Run the utility script:
   ```bash
   doubleA
   ```
2. Follow the interactive menu to perform database operations.

### **Database Operations**

- **Create Database:** Add a new database.
- **List Databases:** Display all existing databases.
- **Connect to Database:** Access a specific database for table operations.
- **Delete Database:** Remove an existing database.
- **Exit:** Quit the DBMS.

### **Table Operations**

Once connected to a database, you can:

- **Create Table:** Add a new table.
- **List Tables:** Display all tables in the database.
- **Connect Table:** Access a specific table for data operations.
- **Drop Table:** Delete a table from the database.
- **Disconnect:** Exit the table management menu.

### **Data Operations**

- **View All Data:** Display all rows and columns in a table.
- **Filter Data:** Display rows matching specific field values.
- **Select Columns:** Display specific columns.

---

## **File Structure**

- **install**: Setup script for the project.
- **db.sh**: Main script for database operations.
- **table.sh**: Script for managing tables.
- **var.sh**: Stores global variables and configurations.
- **Other Scripts:** Additional scripts for specific operations (e.g., `createDB.sh`, `listDBs.sh`).

---

## **Uninstallation**

To remove the project from your system:

1. Delete the installation directory:
   ```bash
   sudo rm -rf /usr/bin/DBMA
   ```
2. Remove the utility script:
   ```bash
   sudo rm /usr/local/bin/doubleA
   ```

---

## **Support**

For any issues or questions, please contact:

- [Ahmed Mohamed Salah](https://github.com/AhmedMohammedSalah)
- [Ahmed Kamal](https://github.com/ahmed-kamal91)

---

## **License**

This project is open-source and distributed under the MIT License.
