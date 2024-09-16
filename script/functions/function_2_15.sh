#!/bin/bash

# Function to check if live restore is enabled in Docker configuration file
check_live_restore_config_file() {
    local config_file="/etc/docker/daemon.json"
    local live_restore_option="live-restore"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker configuration for live restore in $config_file..."
        
        # Look for live-restore option in the Docker config file
        if grep -q "$live_restore_option" "$config_file"; then
            echo "PASS: Live restore is enabled in $config_file."
            return 0
        else
            echo "FAIL: Live restore is NOT enabled in $config_file."
            return 1
        fi
    else
        echo "FAIL: Docker configuration file $config_file does not exist."
        return 1
    fi
}

# Function to check if live restore is enabled via Docker daemon command line
check_live_restore_command_line() {
    # Look for Docker daemon process
    local docker_pid=$(pgrep -f dockerd)
    
    if [[ -z "$docker_pid" ]]; then
        echo "FAIL: Docker daemon is not running or could not be found."
        return 1
    fi

    # Check the command line arguments of the Docker daemon process
    echo "Checking Docker daemon command line for live restore..."

    # Check for live-restore option
    if ps -ef | grep "[d]ockerd" | grep -q -- "--live-restore"; then
        echo "PASS: Live restore is enabled via command line."
        return 0
    else
        echo "FAIL: Live restore is NOT enabled in the Docker daemon command line."
        return 1
    fi
}

# Call the functions to check live restore configuration
check_live_restore_config_file
# Uncomment the next line if you also want to check the command line configuration
check_live_restore_command_line
