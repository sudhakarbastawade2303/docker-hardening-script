#!/bin/bash

# Path to the Docker socket file
DOCKER_SOCKET_PATH="/var/run/docker.sock"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:docker"

# Initialize a status flag
status=0

# Check if the Docker socket file exists
if [[ -e "$DOCKER_SOCKET_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$DOCKER_SOCKET_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $DOCKER_SOCKET_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $DOCKER_SOCKET_PATH is incorrect. Current ownership is $current_owner."
        status=1
        # # Correct the ownership
        # echo "Changing ownership of $DOCKER_SOCKET_PATH to $desired_owner..."
        # sudo chown $desired_owner "$DOCKER_SOCKET_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $DOCKER_SOCKET_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $DOCKER_SOCKET_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The Docker socket file $DOCKER_SOCKET_PATH does not exist. No action taken."
    status=1
fi

exit $status
