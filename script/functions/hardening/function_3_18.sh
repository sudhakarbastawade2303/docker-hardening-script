#!/bin/bash

# Function to ensure /etc/docker/daemon.json file permissions are set to 644 or more restrictive
ensure_daemon_json_permissions() {
    daemon_config_file="/etc/docker/daemon.json"
    required_permissions="644"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file."
        return 1  # FAIL
    fi

    # Check the current permissions of the daemon.json file
    current_permissions=$(stat -c "%a" "$daemon_config_file")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "Daemon.json file permissions are already $current_permissions (644 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting daemon.json file permissions to 644..."
        if chmod 644 "$daemon_config_file"; then
            echo "Daemon.json file permissions set to 644 successfully."
            return 0  # PASS
        else
            echo "Failed to set daemon.json file permissions to 644."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_daemon_json_permissions
