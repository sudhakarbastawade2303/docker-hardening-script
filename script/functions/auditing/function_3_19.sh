#!/bin/bash

# Path to the /etc/default/docker file
DEFAULT_DOCKER_PATH="/etc/default/docker"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:root"

# Initialize a status flag
status=0

# Check if the /etc/default/docker file exists
if [[ -f "$DEFAULT_DOCKER_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$DEFAULT_DOCKER_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $DEFAULT_DOCKER_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $DEFAULT_DOCKER_PATH is incorrect. Current ownership is $current_owner."
        status=1
        # # Correct the ownership
        # echo "Changing ownership of $DEFAULT_DOCKER_PATH to $desired_owner..."
        # sudo chown $desired_owner "$DEFAULT_DOCKER_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $DEFAULT_DOCKER_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $DEFAULT_DOCKER_PATH."
        #     status=1
        # fi
    fi
else
    echo "The /etc/default/docker file $DEFAULT_DOCKER_PATH does not exist. No action taken."
    status=1
fi

return $status
