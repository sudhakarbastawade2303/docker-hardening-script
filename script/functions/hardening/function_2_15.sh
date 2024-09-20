#!/bin/bash

# Function to ensure and configure that Docker live-restore is enabled
configure_live_restore() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "live-restore" setting in the Docker daemon configuration
    if grep -q '"live-restore": true' "$daemon_config_file"; then
        echo "Live restore is already enabled for Docker."
        return 0  # PASS
    else
        echo "Enabling live restore in Docker configuration..."
        jq '. + {"live-restore": true}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Live restore configuration updated successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
configure_live_restore
