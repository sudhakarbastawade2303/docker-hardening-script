#!/bin/bash

# Path to the Docker server certificate key file
DOCKER_SERVER_KEY_PATH="/etc/docker/certs.d/server.key"  # Replace with the actual path

# Desired permissions
desired_permissions="400"

# Check if the Docker server certificate key file exists
if [[ -f "$DOCKER_SERVER_KEY_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$DOCKER_SERVER_KEY_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "The permissions of $DOCKER_SERVER_KEY_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "NOTE: The permissions of $DOCKER_SERVER_KEY_PATH are too permissive. Current permissions are $current_permissions."

        # Correct the permissions
        echo "Changing permissions of $DOCKER_SERVER_KEY_PATH to $desired_permissions..."
        sudo chmod $desired_permissions "$DOCKER_SERVER_KEY_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Permissions of $DOCKER_SERVER_KEY_PATH successfully changed to $desired_permissions."
        else
            echo "ERROR: Failed to change permissions of $DOCKER_SERVER_KEY_PATH."
        fi
    fi
else
    echo "The Docker server certificate key file $DOCKER_SERVER_KEY_PATH does not exist. No action taken."
fi
