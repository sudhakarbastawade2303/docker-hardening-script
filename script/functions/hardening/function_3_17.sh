#!/bin/bash

# Function to ensure /etc/docker/daemon.json file ownership is set to root:root
ensure_daemon_json_ownership() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file."
        return 1  # FAIL
    fi

    # Check the current ownership of the daemon.json file
    current_owner=$(stat -c "%U:%G" "$daemon_config_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "Daemon.json file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting daemon.json file ownership to root:root..."
        if chown root:root "$daemon_config_file"; then
            echo "Daemon.json file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set daemon.json file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_daemon_json_ownership
