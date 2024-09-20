#!/bin/bash

# Function to configure Docker daemon logging level to "info"
configure_logging_level() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "log-level" setting in the Docker daemon configuration
    if grep -q '"log-level": "info"' "$daemon_config_file"; then
        echo "Docker logging level is already set to 'info'."
        return 0  # PASS
    else
        echo "Configuring Docker logging level to 'info'..."
        jq '. + {"log-level": "info"}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Docker logging level set to 'info' successfully. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    fi
}

# Call the function
configure_logging_level
