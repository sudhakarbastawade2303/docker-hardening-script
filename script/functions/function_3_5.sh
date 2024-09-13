#!/bin/bash

# Path to the /etc/docker directory
DOCKER_DIR_PATH="/etc/docker"

# Desired ownership
desired_owner="root:root"

# Check if the /etc/docker directory exists
if [[ -d "$DOCKER_DIR_PATH" ]]; then
    # Get the current ownership of the directory
    current_owner=$(stat -c "%U:%G" "$DOCKER_DIR_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "The ownership of $DOCKER_DIR_PATH is correctly set to $desired_owner."
    else
        echo "NOTE: The ownership of $DOCKER_DIR_PATH is incorrect. Current ownership is $current_owner."

        # Correct the ownership
        echo "Changing ownership of $DOCKER_DIR_PATH to $desired_owner..."
        sudo chown root:root "$DOCKER_DIR_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Ownership of $DOCKER_DIR_PATH successfully changed to $desired_owner."
        else
            echo "ERROR: Failed to change ownership of $DOCKER_DIR_PATH."
        fi
    fi
else
    echo "The directory $DOCKER_DIR_PATH does not exist. No action taken."
fi