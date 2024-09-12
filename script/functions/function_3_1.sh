#!/bin/bash

# Path to the docker.service file
SERVICE_FILE_PATH="/usr/lib/systemd/system/docker.service"  # Adjust path if necessary

# Check if the docker.service file exists
if [[ -f "$SERVICE_FILE_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$SERVICE_FILE_PATH")

    # Desired ownership
    desired_owner="root:root"

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "The ownership of $SERVICE_FILE_PATH is correctly set to $desired_owner."
    else
        echo "NOTE: The ownership of $SERVICE_FILE_PATH is incorrect. Current ownership is $current_owner."

        # Correct the ownership
        echo "Changing ownership of $SERVICE_FILE_PATH to $desired_owner..."
        sudo chown root:root "$SERVICE_FILE_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Ownership of $SERVICE_FILE_PATH successfully changed to $desired_owner."
        else
            echo "ERROR: Failed to change ownership of $SERVICE_FILE_PATH."
        fi
    fi
else
    echo "The file $SERVICE_FILE_PATH does not exist. No action taken."
fi
