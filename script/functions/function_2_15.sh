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
            echo "Live restore is enabled in $config_file."
        else
            echo "NOTE: Live restore is NOT enabled in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

>>'###'
# Function to check if live restore is enabled via Docker daemon command line
check_live_restore_command_line() {
    # Look for Docker daemon process
    local docker_pid=$(pgrep -f dockerd)
    
    if [[ -z "$docker_pid" ]]; then
        echo "NOTE: Docker daemon is not running or could not be found."
        return
    fi

    # Check the command line arguments of the Docker daemon process
    echo "Checking Docker daemon command line for live restore..."

    # Check for live-restore option
    local live_restore=$(ps -ef | grep "[d]ockerd" | grep -oP '(?<=--live-restore)')

    if [[ -n "$live_restore" ]]; then
        echo "Live restore is enabled via command line."
    else
        echo "NOTE: Live restore is NOT enabled in the Docker daemon command line."
    fi
}
###

# Call the functions to check live restore configuration
check_live_restore_config_file
#check_live_restore_command_line
