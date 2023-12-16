#!/bin/bash

DB_NAME="moodle_database"
OUTPUT_FILE="moodle_$(date +'%Y_%m_%d|%H:%M:%S').sql"
CONFIG_FILE="mysql_config.cnf"

mysqldump --defaults-extra-file="$CONFIG_FILE" "$DB_NAME" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Database dump successful. File saved as: $OUTPUT_FILE"
else
    echo "Error: Database dump failed."
fi

