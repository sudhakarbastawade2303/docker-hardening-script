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
        echo "PASS: The permissions of $DOCKER_DIR_PATH are correctly set to $current_permissions or more restrictive."
        return 0
    else
        echo "FAIL: The permissions of $DOCKER_DIR_PATH are too permissive. Current permissions are $current_permissions."
        return 1

        # # Correct the permissions
        # echo "Changing permissions of $DOCKER_DIR_PATH to $desired_permissions..."
        # sudo chmod $desired_permissions "$DOCKER_DIR_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Permissions of $DOCKER_DIR_PATH successfully changed to $desired_permissions."
        #     return 0
        # else
        #     echo "ERROR: Failed to change permissions of $DOCKER_DIR_PATH."
        #     return 1
        # fi
    fi
else
    echo "FAIL: The directory $DOCKER_DIR_PATH does not exist. No action taken."
    return 1
fi
