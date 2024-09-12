#!/bin/bash

# Path to the docker.socket file
SOCKET_FILE_PATH="/usr/lib/systemd/system/docker.socket"  # Adjust path if necessary

# Desired ownership
desired_owner="root:root"

# Check if the docker.socket file exists
if [[ -f "$SOCKET_FILE_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$SOCKET_FILE_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "The ownership of $SOCKET_FILE_PATH is correctly set to $desired_owner."
    else
        echo "NOTE: The ownership of $SOCKET_FILE_PATH is incorrect. Current ownership is $current_owner."

        # Correct the ownership
        echo "Changing ownership of $SOCKET_FILE_PATH to $desired_owner..."
        sudo chown root:root "$SOCKET_FILE_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Ownership of $SOCKET_FILE_PATH successfully changed to $desired_owner."
        else
            echo "ERROR: Failed to change ownership of $SOCKET_FILE_PATH."
        fi
    fi
else
    echo "The file $SOCKET_FILE_PATH does not exist. No action taken."
fi
