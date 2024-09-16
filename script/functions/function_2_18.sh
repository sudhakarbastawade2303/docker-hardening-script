#!/bin/bash

# Function to check if experimental features are enabled in Docker configuration file
check_experimental_config_file() {
    local config_file="/etc/docker/daemon.json"
    local experimental_option="experimental"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker configuration for experimental features in $config_file..."
        
        # Look for experimental option in the Docker config file
        if grep -q "$experimental_option" "$config_file"; then
            if grep -q '"experimental": true' "$config_file"; then
                echo "PASS: Experimental features are ENABLED in $config_file."
                return 0
            else
                echo "Experimental features are DISABLED in $config_file."
                return 1
            fi
        else
            echo "FAIL: Experimental features are NOT configured in $config_file."
            return 1
        fi
    else
        echo "FAIL: Docker configuration file $config_file does not exist."
        return 1
    fi
}

# Call the function to check experimental features configuration
check_experimental_config_file
