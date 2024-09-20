#!/bin/bash

# Function to ensure containers are restricted from acquiring new privileges
validate_no_new_privileges() {
    local daemon_config_file="/etc/docker/daemon.json"
    
    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "FAIL: Docker daemon configuration file does not exist at $daemon_config_file."
        return 1  # FAIL
    fi

    # Check if "no-new-privileges" is set to true
    if jq -e '.["no-new-privileges"] == true' "$daemon_config_file" > /dev/null 2>&1; then
        echo "PASS: Containers are restricted from acquiring new privileges."
    else
        echo "FAIL: Containers are not restricted from acquiring new privileges."
        echo "NOTE: You need to add the following line to $daemon_config_file:"
        echo '"no-new-privileges": true'
        echo "After adding the line, restart the Docker daemon with: sudo systemctl restart docker"
        return 1  # FAIL
    fi

    return 0  # PASS
}

# Run the function
validate_no_new_privileges
