#!/bin/bash

# Function to ensure and configure containers are restricted from acquiring new privileges
configure_no_new_privileges() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "no-new-privileges" setting in the Docker daemon configuration
    if grep -q '"no-new-privileges": true' "$daemon_config_file"; then
        echo "Containers are already restricted from acquiring new privileges."
        return 0  # PASS
    else
        echo "Configuring Docker to restrict containers from acquiring new privileges..."
        jq '. + {"no-new-privileges": true}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Docker configuration updated successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
configure_no_new_privileges
