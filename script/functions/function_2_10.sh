#!/bin/bash

# Function to check default cgroup usage
check_cgroup_usage() {
    local config_file="/etc/docker/daemon.json"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        # Look for the cgroup-driver option in the Docker config file
        if grep -q '"cgroup-driver"' "$config_file"; then
            echo "PASS: Default cgroup driver is configured."
            return 0
        else
            echo "FAIL: Default cgroup driver is NOT configured in $config_file."
            return 1
        fi
    else
        echo "FAIL: Docker configuration file $config_file does not exist."
        return 1
    fi
}

# Call the function to check cgroup usage
check_cgroup_usage
