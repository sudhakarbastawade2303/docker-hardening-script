#!/bin/bash

# Path to the Docker server certificate key file
DOCKER_SERVER_KEY_PATH="/etc/docker/certs.d/server.key"  # Replace with the actual path

# Desired ownership
desired_owner="root:root"

# Initialize a status flag
status=0

# Check if the Docker server certificate key file exists
if [[ -f "$DOCKER_SERVER_KEY_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$DOCKER_SERVER_KEY_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $DOCKER_SERVER_KEY_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $DOCKER_SERVER_KEY_PATH is incorrect. Current ownership is $current_owner."
        status=1
        # # Correct the ownership
        # echo "Changing ownership of $DOCKER_SERVER_KEY_PATH to $desired_owner..."
        # sudo chown $desired_owner "$DOCKER_SERVER_KEY_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $DOCKER_SERVER_KEY_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $DOCKER_SERVER_KEY_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The Docker server certificate key file $DOCKER_SERVER_KEY_PATH does not exist. No action taken."
    status=1
fi

return $status
