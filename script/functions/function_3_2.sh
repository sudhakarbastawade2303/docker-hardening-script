#!/bin/bash

# Path to the docker.service file
SERVICE_FILE_PATH="/usr/lib/systemd/system/docker.service"  # Adjust path if necessary

# Desired permissions
desired_permissions="644"

# Check if the docker.service file exists
if [[ -f "$SERVICE_FILE_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$SERVICE_FILE_PATH")

    # Check if the current permissions match the desired permissions
    if [[ "$current_permissions" == "$desired_permissions" ]]; then
        echo "The permissions of $SERVICE_FILE_PATH are correctly set to $desired_permissions."
    else
        echo "NOTE: The permissions of $SERVICE_FILE_PATH are incorrect. Current permissions are $current_permissions."

        # Correct the permissions
        echo "Changing permissions of $SERVICE_FILE_PATH to $desired_permissions..."
        sudo chmod $desired_permissions "$SERVICE_FILE_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Permissions of $SERVICE_FILE_PATH successfully changed to $desired_permissions."
        else
            echo "ERROR: Failed to change permissions of $SERVICE_FILE_PATH."
        fi
    fi
else
    echo "The file $SERVICE_FILE_PATH does not exist. No action taken."
fi
