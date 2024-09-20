#!/bin/bash

# Function to configure Docker daemon to not use AUFS storage driver
configure_docker_storage_driver() {
    daemon_config_file="/etc/docker/daemon.json"

    # Check if the Docker daemon configuration file exists
    if [[ ! -f "$daemon_config_file" ]]; then
        echo "Docker daemon configuration file does not exist at $daemon_config_file. Creating new configuration file."
        echo "{}" > "$daemon_config_file"
    fi

    # Add or update the "storage-driver" setting in the Docker daemon configuration
    if grep -q '"storage-driver": "aufs"' "$daemon_config_file"; then
        echo "Docker is configured to use AUFS storage driver. Updating configuration to use a different driver..."
        jq '. + {"storage-driver": "overlay2"}' "$daemon_config_file" > /tmp/daemon.json
        mv /tmp/daemon.json "$daemon_config_file"

        # Mark Docker for restart at the end of the hardening process
        echo "Docker storage driver updated to overlay2. Docker restart required."
        touch /tmp/docker_restart_required

        return 0  # PASS
    else
        echo "Docker is not using AUFS storage driver."
        return 0  # PASS
    fi
}

# Call the function
configure_docker_storage_driver
