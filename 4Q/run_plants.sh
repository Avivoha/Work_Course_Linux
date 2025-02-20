#!/bin/bash

# Log file path
LOG_FILE="$(dirname "$0")/run_plants.log"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Validate input
if [[ -z "$1" ]]; then
    log "Error: No CSV file provided."
    exit 1
fi

CSV_FILE="$1"

if [[ ! -f "$CSV_FILE" ]]; then
    log "Error: CSV file '$CSV_FILE' not found!"
    exit 1
fi

# Create virtual environment if not exists
VENV_PATH=~/plants_venv
if [[ ! -d "$VENV_PATH" ]]; then
    log "Creating new virtual environment..."
    python3 -m venv "$VENV_PATH"
fi

# Activate virtual environment
source "$VENV_PATH/bin/activate"
log "Virtual environment activated."

# Install dependencies if not installed
pip show numpy &>/dev/null || pip install numpy
pip show matplotlib &>/dev/null || pip install matplotlib
log "Dependencies installed."

# Read CSV and execute plant.py for each plant
tail -n +2 "$CSV_FILE" | while IFS=',' read -r plant height leaf_count dry_weight; do
    # Trim whitespace and remove quotes
    plant=$(echo "$plant" | tr -d '\"')
    height=$(echo "$height" | tr -d '\"')
    leaf_count=$(echo "$leaf_count" | tr -d '\"')
    dry_weight=$(echo "$dry_weight" | tr -d '\"')

    # Create directory for the plant
    PLANT_DIR="~/Work_Course_Linux/4Q/$plant"
    mkdir -p "$PLANT_DIR"

    # Run Python script
    log "Running plant.py for $plant..."
    python3 ~/Work_Course_Linux/4Q/plant.py --plant "$plant" --height $height --leaf_count $leaf_count --dry_weight $dry_weight

    # Move generated images to the plant directory
    mv ~/Work_Course_Linux/4Q/*.png "$PLANT_DIR/" 2>/dev/null

    # Verify that images were created
    if [[ -z "$(ls -A "$PLANT_DIR"/*.png 2>/dev/null)" ]]; then
        log "Error: No images generated for $plant."
    else
        log "Successfully generated images for $plant."
    fi
done

log "Script execution completed."
