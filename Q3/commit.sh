#!/bin/bash

# Define the correct path to the CSV file
CSV_FILE="$(cd "$(dirname "$0")" && pwd)/bugs.csv"

# Validation: Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: CSV file '$CSV_FILE' not found!"
    exit 1
fi

# Get the current Git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Search for the bug data corresponding to the current branch in the CSV file
BUG_DATA=$(awk -F',' -v branch="$BRANCH" '$4 == branch {print $1 ":" strftime("%Y-%m-%d %H:%M:%S") ":" $4 ":" $3 ":" $2 ":" $5}' "$CSV_FILE")

# Validation: Ensure that bug data was found for the current branch
if [[ -z "$BUG_DATA" ]]; then
    echo "Error: No matching entry for branch '$BRANCH' in CSV file."
    exit 1
fi

# Add developer's additional comment if provided
DEV_DESCRIPTION="$1"
if [[ -n "$DEV_DESCRIPTION" ]]; then
    COMMIT_MESSAGE="$BUG_DATA:$DEV_DESCRIPTION"
else
    COMMIT_MESSAGE="$BUG_DATA"
fi

# Perform Git staging, commit, and push
git add .
git commit -m "$COMMIT_MESSAGE"
if git push origin "$BRANCH"; then
    echo "Commit and push successful: $COMMIT_MESSAGE"
else
    echo "Error: Push failed!"
    exit 1
fi
