#!/bin/bash

# Function to check if Docker daemon is configured to restrict privilege escalation
check_privilege_escalation_config_file() {
    local config_file="/etc/docker/daemon.json"
    local security_opt="security-opt"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker configuration for privilege escalation restrictions in $config_file..."
        
        # Look for security options related to privilege escalation
        if grep -q "$security_opt" "$config_file"; then
            echo "Docker is configured with security options to restrict privilege escalation."
        else
            echo "NOTE: Docker is NOT configured with security options to restrict privilege escalation in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Call the functions to check privilege escalation restrictions
check_privilege_escalation_config_file