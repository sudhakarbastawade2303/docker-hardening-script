#!/bin/bash

# Path to the /etc/docker directory
DOCKER_DIR_PATH="/etc/docker"

# Desired permissions
desired_permissions="755"

# Check if the /etc/docker directory exists
if [[ -d "$DOCKER_DIR_PATH" ]]; then
    # Get the current permissions of the directory
    current_permissions=$(stat -c "%a" "$DOCKER_DIR_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "The permissions of $DOCKER_DIR_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "NOTE: The permissions of $DOCKER_DIR_PATH are too permissive. Current permissions are $current_permissions."

        # Correct the permissions
        echo "Changing permissions of $DOCKER_DIR_PATH to $desired_permissions..."
        sudo chmod $desired_permissions "$DOCKER_DIR_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Permissions of $DOCKER_DIR_PATH successfully changed to $desired_permissions."
        else
            echo "ERROR: Failed to change permissions of $DOCKER_DIR_PATH."
        fi
    fi
else
    echo "The directory $DOCKER_DIR_PATH does not exist. No action taken."
fi
