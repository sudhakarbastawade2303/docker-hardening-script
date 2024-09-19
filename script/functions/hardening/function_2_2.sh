#!/bin/bash

# Function to configure Docker daemon to restrict network traffic between containers on the default bridge
restrict_network_traffic() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "icc" setting in the Docker daemon configuration
    if grep -q '"icc": false' "$daemon_config_file"; then
        echo "Network traffic restriction is already configured in Docker daemon configuration."
        return 0  # PASS
    else
        echo "Configuring network traffic restriction in Docker daemon configuration..."
        jq '. + {icc: false}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Network traffic restriction added successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
restrict_network_traffic