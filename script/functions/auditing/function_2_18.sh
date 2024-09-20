#!/bin/bash

# Function to check if experimental features are disabled in Docker configuration file
check_experimental_config_file() {
    local config_file="/etc/docker/daemon.json"
    local experimental_option='"experimental": false'

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker configuration for experimental features in $config_file..."
        
        # Look for the experimental option in the Docker config file
        if jq -e ".[\"experimental\"] == false" "$config_file" > /dev/null; then
            echo "PASS: Experimental features are DISABLED in $config_file."
            return 0
        else
            echo "FAIL: Experimental features are NOT disabled in $config_file."
            echo "NOTE: You need to set the following line in $config_file:"
            echo "$experimental_option"
            echo "After adding the line, restart the Docker daemon with: sudo systemctl restart docker"
            return 1
        fi
    else
        echo "FAIL: Docker configuration file $config_file does not exist."
        return 1
    fi
}

# Run the function
check_experimental_config_file
