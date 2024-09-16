#!/bin/bash

# Path to the Docker socket file
DOCKER_SOCKET_PATH="/var/run/docker.sock"  # Replace with the actual path if different

# Desired permissions
desired_permissions="660"

# Initialize a status flag
status=0

# Check if the Docker socket file exists
if [[ -e "$DOCKER_SOCKET_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$DOCKER_SOCKET_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "PASS: The permissions of $DOCKER_SOCKET_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "FAIL: The permissions of $DOCKER_SOCKET_PATH are too permissive. Current permissions are $current_permissions."

        # # Correct the permissions
        # echo "Changing permissions of $DOCKER_SOCKET_PATH to $desired_permissions..."
        # sudo chmod $desired_permissions "$DOCKER_SOCKET_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Permissions of $DOCKER_SOCKET_PATH successfully changed to $desired_permissions."
        # else
        #     echo "ERROR: Failed to change permissions of $DOCKER_SOCKET_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The Docker socket file $DOCKER_SOCKET_PATH does not exist. No action taken."
    status=1
fi

return $status
