#!/bin/bash

# Path to the /etc/sysconfig/docker file
SYS_CONFIG_DOCKER_PATH="/etc/sysconfig/docker"  # Replace with the actual path if different

# Desired permissions
desired_permissions="644"

# Check if the /etc/sysconfig/docker file exists
if [[ -f "$SYS_CONFIG_DOCKER_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$SYS_CONFIG_DOCKER_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "The permissions of $SYS_CONFIG_DOCKER_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "NOTE: The permissions of $SYS_CONFIG_DOCKER_PATH are too permissive. Current permissions are $current_permissions."

        # Correct the permissions
        echo "Changing permissions of $SYS_CONFIG_DOCKER_PATH to $desired_permissions..."
        sudo chmod $desired_permissions "$SYS_CONFIG_DOCKER_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Permissions of $SYS_CONFIG_DOCKER_PATH successfully changed to $desired_permissions."
        else
            echo "ERROR: Failed to change permissions of $SYS_CONFIG_DOCKER_PATH."
        fi
    fi
else
    echo "The /etc/sysconfig/docker file $SYS_CONFIG_DOCKER_PATH does not exist. No action taken."
fi
