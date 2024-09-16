#!/bin/bash

# Path to the /etc/sysconfig/docker file
SYS_CONFIG_DOCKER_PATH="/etc/sysconfig/docker"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:root"

# Initialize a status flag
status=0

# Check if the /etc/sysconfig/docker file exists
if [[ -f "$SYS_CONFIG_DOCKER_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$SYS_CONFIG_DOCKER_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $SYS_CONFIG_DOCKER_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $SYS_CONFIG_DOCKER_PATH is incorrect. Current ownership is $current_owner."

        # # Correct the ownership
        # echo "Changing ownership of $SYS_CONFIG_DOCKER_PATH to $desired_owner..."
        # sudo chown $desired_owner "$SYS_CONFIG_DOCKER_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $SYS_CONFIG_DOCKER_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $SYS_CONFIG_DOCKER_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The /etc/sysconfig/docker file $SYS_CONFIG_DOCKER_PATH does not exist. No action taken."
    status=1
fi

exit $status
