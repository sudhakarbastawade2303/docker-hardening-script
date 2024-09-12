#!/bin/bash

# Function to check default cgroup usage
check_cgroup_usage() {
    local config_file="/etc/docker/daemon.json"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        # Look for the cgroup-driver option in the Docker config file
        if grep -q '"cgroup-driver"' "$config_file"; then
            echo "Default cgroup driver is configured."
        else
            echo "NOTE: Default cgroup driver is NOT configured in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Call the function to check cgroup usage
check_cgroup_usage
