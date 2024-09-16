#!/bin/bash

# Path to the docker.socket file
SOCKET_FILE_PATH="/lib/systemd/system/docker.socket"  # Adjust path if necessary

# Desired permissions
desired_permissions="644"

# Check if the docker.socket file exists
if [[ -f "$SOCKET_FILE_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$SOCKET_FILE_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "PASS: The permissions of $SOCKET_FILE_PATH are correctly set to $current_permissions or more restrictive."
        return 0
    else
        echo "FAIL: NOTE: The permissions of $SOCKET_FILE_PATH are too permissive. Current permissions are $current_permissions."
        return 1 
        # # Correct the permissions
        # echo "Changing permissions of $SOCKET_FILE_PATH to $desired_permissions..."
        # sudo chmod $desired_permissions "$SOCKET_FILE_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Permissions of $SOCKET_FILE_PATH successfully changed to $desired_permissions."
        #     return 0
        # else
        #     echo "ERROR: Failed to change permissions of $SOCKET_FILE_PATH."
        #     return 1
        # fi
    fi
else
    echo "FAIL: The file $SOCKET_FILE_PATH does not exist. No action taken."
    return 1
fi
