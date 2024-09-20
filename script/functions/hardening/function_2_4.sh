#!/bin/bash

# Function to check and configure Docker daemon to allow changes to iptables
configure_docker_iptables() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "iptables" setting in the Docker daemon configuration
    if grep -q '"iptables": true' "$daemon_config_file"; then
        echo "Docker is already allowed to make changes to iptables."
        return 0  # PASS
    else
        echo "Configuring Docker to allow changes to iptables..."
        jq '. + {"iptables": true}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Docker iptables configuration added successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
configure_docker_iptables
