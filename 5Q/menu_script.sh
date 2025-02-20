#!/bin/bash

CSV_FILE="~/Work_Course_Linux/5Q/data.csv"
LOG_FILE="~/Work_Course_Linux/5Q/txt.output_5"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to create a new CSV file
create_csv() {
    read -p "Enter the name of the CSV file: " filename
    CSV_FILE="~/Work_Course_Linux/5Q/$filename.csv"
    echo "Date collected,Species,Sex,Weight" > "$CSV_FILE"
    log "Created new CSV file: $CSV_FILE"
}

# Function to display CSV content with row index
display_csv() {
    nl -w2 -s", " "$CSV_FILE"
    log "Displayed CSV data"
}

# Function to add a new row
add_row() {
    read -p "Enter Date collected: " date
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight
    echo "$date,$species,$sex,$weight" >> "$CSV_FILE"
    log "Added row: $date, $species, $sex, $weight"
}

# Function to filter by species and calculate average weight
filter_by_species() {
    read -p "Enter species to search: " species
    grep "$species" "$CSV_FILE" | tee -a "$LOG_FILE"
    awk -F',' -v sp="$species" '$2 == sp {sum+=$4; count++} END {if (count>0) print "Average weight:", sum/count; else print "No records found"}' "$CSV_FILE" | tee -a "$LOG_FILE"
}

# Function to filter by sex
filter_by_sex() {
    read -p "Enter sex (M/F) to search: " sex
    grep ",$sex," "$CSV_FILE" | tee -a "$LOG_FILE"
    log "Filtered data by sex: $sex"
}

# Function to save last output to a new file
save_last_output() {
    cp "$LOG_FILE" "$CSV_FILE"_backup_20250220214439.csv
    log "Saved last output to new CSV file"
}

# Function to delete a row by index
delete_row() {
    read -p "Enter row number to delete: " row
    sed -i "${row}d" "$CSV_FILE"
    log "Deleted row: $row"
}

# Function to update weight by row index
update_weight() {
    read -p "Enter row number to update: " row
    read -p "Enter new weight: " weight
    awk -F',' -v r="$row" -v w="$weight" 'NR==r { $4=w } 1' OFS=',' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    log "Updated weight at row: $row with weight: $weight"
}

# Menu loop
while true; do
    echo "Choose an option:"
    echo "1. Create CSV by name"
    echo "2. Display all CSV data with row index"
    echo "3. Read user input for new row"
    echo "4. Read species and display all items with average weight"
    echo "5. Read species sex (M/F) and display all items of that type"
    echo "6. Save last output to new CSV file"
    echo "7. Delete row by row index"
    echo "8. Update weight by row index"
    echo "9. Exit"

    read -p "Enter choice: " choice
    case $choice in
        1) create_csv ;;
        2) display_csv ;;
        3) add_row ;;
        4) filter_by_species ;;
        5) filter_by_sex ;;
        6) save_last_output ;;
        7) delete_row ;;
        8) update_weight ;;
        9) log "User exited the menu"; exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
