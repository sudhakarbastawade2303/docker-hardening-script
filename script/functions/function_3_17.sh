#!/bin/bash

# Path to the daemon.json file
DAEMON_JSON_PATH="/etc/docker/daemon.json"  # Replace with the actual path if different

# Desired ownership
desired_owner="root:root"

# Check if the daemon.json file exists
if [[ -f "$DAEMON_JSON_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$DAEMON_JSON_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "The ownership of $DAEMON_JSON_PATH is correctly set to $desired_owner."
    else
        echo "NOTE: The ownership of $DAEMON_JSON_PATH is incorrect. Current ownership is $current_owner."

        # Correct the ownership
        echo "Changing ownership of $DAEMON_JSON_PATH to $desired_owner..."
        sudo chown $desired_owner "$DAEMON_JSON_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Ownership of $DAEMON_JSON_PATH successfully changed to $desired_owner."
        else
            echo "ERROR: Failed to change ownership of $DAEMON_JSON_PATH."
        fi
    fi
else
    echo "The daemon.json file $DAEMON_JSON_PATH does not exist. No action taken."
fi
