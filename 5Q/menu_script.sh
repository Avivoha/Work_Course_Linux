#!/bin/bash

DB_FILE="/home/avivoha/Work_Course_Linux/5Q/data.db"
LOG_FILE="/home/avivoha/Work_Course_Linux/5Q/txt.output_5"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to display all data
display_db() {
    sqlite3 "$DB_FILE" "SELECT rowid, * FROM specimens;" | tee -a "$LOG_FILE"
    log "Displayed DB data"
}

# Function to add a new row
add_row() {
    read -p "Enter Date collected: " date
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight
    sqlite3 "$DB_FILE" "INSERT INTO specimens (date_collected, species, sex, weight) VALUES ('', '', '', '');"
    log "Added row: $date, $species, $sex, $weight"
}

# Function to filter by species and calculate average weight
filter_by_species() {
    read -p "Enter species to search: " species
    sqlite3 "$DB_FILE" "SELECT * FROM specimens WHERE species='';" | tee -a "$LOG_FILE"
    sqlite3 "$DB_FILE" "SELECT AVG(weight) FROM specimens WHERE species='';" | tee -a "$LOG_FILE"
}

# Function to filter by sex
filter_by_sex() {
    read -p "Enter sex (M/F) to search: " sex
    sqlite3 "$DB_FILE" "SELECT * FROM specimens WHERE sex='';" | tee -a "$LOG_FILE"
    log "Filtered data by sex: $sex"
}

# Function to delete a row by row index
delete_row() {
    read -p "Enter row ID to delete: " row
    sqlite3 "$DB_FILE" "DELETE FROM specimens WHERE rowid='$row';"
    log "Deleted row: $row"
}

# Function to update weight by row ID
update_weight() {
    read -p "Enter row ID to update: " row
    read -p "Enter new weight: " weight
    sqlite3 "$DB_FILE" "UPDATE specimens SET weight='$weight' WHERE rowid='$row';"
    log "Updated weight at row: $row with weight: $weight"
}

# Menu loop
while true; do
    echo "Choose an option:"
    echo "2. Display all database records"
    echo "3. Read user input for new record"
    echo "4. Read species and display all items with average weight"
    echo "5. Read species sex (M/F) and display all items of that type"
    echo "7. Delete row by row ID"
    echo "8. Update weight by row ID"
    echo "9. Exit"

    read -p "Enter choice: " choice
    case $choice in
        2) display_db ;;
        3) add_row ;;
        4) filter_by_species ;;
        5) filter_by_sex ;;
        7) delete_row ;;
        8) update_weight ;;
        9) log "User exited the menu"; exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
