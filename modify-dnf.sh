#!/bin/bash

# Define the file and the desired values
FILE="/etc/dnf/dnf.conf"
MAX_PARALLEL_DOWNLOADS="max_parallel_downloads=10"
FASTESTMIRROR="fastestmirror=true"
CHANGES_NEEDED=false

# Check if the file exists
if [ ! -f "$FILE" ]; then
  echo "File $FILE does not exist."
  exit 1
fi

# Function to check if a change is needed
check_if_change_needed() {
  local key_value=$1
  local key=$(echo $key_value | cut -d'=' -f1)
  local value=$(echo $key_value | cut -d'=' -f2)

  if grep -q "^$key=" "$FILE"; then
    current_value=$(grep "^$key=" "$FILE" | cut -d'=' -f2)
    echo "Current value of $key is $current_value"
    if [ "$current_value" != "$value" ]; then
      CHANGES_NEEDED=true
    fi
  else
    CHANGES_NEEDED=true
  fi
}

# Function to apply the changes
apply_changes() {
  local key_value=$1
  local key=$(echo $key_value | cut -d'=' -f1)
  local value=$(echo $key_value | cut -d'=' -f2)

  if grep -q "^$key=" "$FILE"; then
    sed -i "s/^$key=.*/$key=$value/" "$FILE"
    echo "Updated $key to $value"
  else
    echo "$key_value" | sudo tee -a "$FILE" > /dev/null
    echo "Added $key_value to $FILE"
  fi
}

# Check if changes are needed
check_if_change_needed "$MAX_PARALLEL_DOWNLOADS"
check_if_change_needed "$FASTESTMIRROR"

# If changes are needed, create a backup and apply the changes
if [ "$CHANGES_NEEDED" = true ]; then
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  BACKUP_FILE="${FILE}.bak.${TIMESTAMP}"
  sudo cp "$FILE" "$BACKUP_FILE"
  echo "Backup of $FILE created at $BACKUP_FILE"

  # Apply the changes
  apply_changes "$MAX_PARALLEL_DOWNLOADS"
  apply_changes "$FASTESTMIRROR"
else
  echo "No changes needed."
fi
