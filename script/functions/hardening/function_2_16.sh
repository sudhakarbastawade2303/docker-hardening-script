#!/bin/bash

# Function to ensure and configure that Docker userland proxy is disabled
disable_userland_proxy() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "userland-proxy" setting in the Docker daemon configuration
    if grep -q '"userland-proxy": false' "$daemon_config_file"; then
        echo "Userland proxy is already disabled for Docker."
        return 0  # PASS
    else
        echo "Disabling userland proxy in Docker configuration..."
        jq '. + {"userland-proxy": false}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Userland proxy disabled successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
disable_userland_proxy
