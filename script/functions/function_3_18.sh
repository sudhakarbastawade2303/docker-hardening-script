#!/bin/bash

# Path to the daemon.json file
DAEMON_JSON_PATH="/etc/docker/daemon.json"  # Replace with the actual path if different

# Desired permissions
desired_permissions="644"

# Initialize a status flag
status=0

# Check if the daemon.json file exists
if [[ -f "$DAEMON_JSON_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$DAEMON_JSON_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "PASS: The permissions of $DAEMON_JSON_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "FAIL: The permissions of $DAEMON_JSON_PATH are too permissive. Current permissions are $current_permissions."
        status=1
        # # Correct the permissions
        # echo "Changing permissions of $DAEMON_JSON_PATH to $desired_permissions..."
        # sudo chmod $desired_permissions "$DAEMON_JSON_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Permissions of $DAEMON_JSON_PATH successfully changed to $desired_permissions."
        # else
        #     echo "ERROR: Failed to change permissions of $DAEMON_JSON_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The daemon.json file $DAEMON_JSON_PATH does not exist. No action taken."
    status=1
fi

exit $status
