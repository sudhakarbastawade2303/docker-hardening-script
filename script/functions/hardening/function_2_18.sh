#!/bin/bash

# Function to ensure that Docker experimental features are disabled
disable_experimental_features() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "experimental" setting in the Docker daemon configuration
    if grep -q '"experimental": false' "$daemon_config_file"; then
        echo "Experimental features are already disabled in Docker."
        return 0  # PASS
    else
        echo "Disabling experimental features in Docker configuration..."
        jq '. + {"experimental": false}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Experimental features disabled successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
disable_experimental_features
