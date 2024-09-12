#!/bin/bash

# Path to the containerd socket file
SOCKET_FILE_PATH="/run/containerd/containerd.sock"  # Replace with the actual path if different

# Desired permissions
desired_permissions="660"

# Check if the containerd socket file exists
if [[ -S "$SOCKET_FILE_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$SOCKET_FILE_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "The permissions of $SOCKET_FILE_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "NOTE: The permissions of $SOCKET_FILE_PATH are too permissive. Current permissions are $current_permissions."

        # Correct the permissions
        echo "Changing permissions of $SOCKET_FILE_PATH to $desired_permissions..."
        sudo chmod $desired_permissions "$SOCKET_FILE_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Permissions of $SOCKET_FILE_PATH successfully changed to $desired_permissions."
        else
            echo "ERROR: Failed to change permissions of $SOCKET_FILE_PATH."
        fi
    fi
else
    echo "The containerd socket file $SOCKET_FILE_PATH does not exist. No action taken."
fi
