#!/bin/bash

# Path to the daemon.json file
DAEMON_JSON_PATH="/etc/docker/daemon.json"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:root"

# Initialize a status flag
status=0

# Check if the daemon.json file exists
if [[ -f "$DAEMON_JSON_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$DAEMON_JSON_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "PASS: The ownership of $DAEMON_JSON_PATH is correctly set to $desired_owner."
    else
        echo "FAIL: The ownership of $DAEMON_JSON_PATH is incorrect. Current ownership is $current_owner."
        status=1
        # # Correct the ownership
        # echo "Changing ownership of $DAEMON_JSON_PATH to $desired_owner..."
        # sudo chown $desired_owner "$DAEMON_JSON_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Ownership of $DAEMON_JSON_PATH successfully changed to $desired_owner."
        # else
        #     echo "ERROR: Failed to change ownership of $DAEMON_JSON_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The daemon.json file $DAEMON_JSON_PATH does not exist. No action taken."
    status=1
fi

exit $status
