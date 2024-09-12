#!/bin/bash

# Function to check if base device size is configured
check_base_device_size() {
    local config_file="/etc/docker/daemon.json"
    local base_device_size_key="base-device-size"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        # Look for the base device size option in the Docker config file
        if grep -q "$base_device_size_key" "$config_file"; then
            echo "Base device size is configured in $config_file."
        else
            echo "NOTE: Base device size is NOT configured in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Call the functions to check base device size
check_base_device_size