#!/bin/bash

# Path to the containerd socket file
SOCKET_FILE_PATH="/run/containerd/containerd.sock"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:root"

# Initialize a status flag
status=0

# Check if the containerd socket file exists
if [[ -S "$SOCKET_FILE_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$SOCKET_FILE_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $SOCKET_FILE_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $SOCKET_FILE_PATH is incorrect. Current ownership is $current_owner."

        # # Correct the ownership
        # echo "Changing ownership of $SOCKET_FILE_PATH to $desired_owner..."
        # sudo chown $desired_owner "$SOCKET_FILE_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $SOCKET_FILE_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $SOCKET_FILE_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The containerd socket file $SOCKET_FILE_PATH does not exist. No action taken."
    status=1
fi

exit $status
