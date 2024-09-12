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
                echo "NOTE: Experimental features are ENABLED in $config_file."
            else
                echo "Experimental features are DISABLED in $config_file."
            fi
        else
            echo "Experimental features are NOT configured in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Call the functions to check experimental features configuration
check_experimental_config_file