#!/bin/bash

# Function to check if userland proxy is disabled in the Docker config file
check_userland_proxy_config_file() {
    local config_file="/etc/docker/daemon.json"
    local userland_proxy_option="userland-proxy"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker configuration for userland proxy in $config_file..."
        
        # Look for userland-proxy option in the Docker config file
        if grep -q "$userland_proxy_option" "$config_file" && grep -q '"userland-proxy": false' "$config_file"; then
            echo "Userland proxy is disabled in $config_file."
        else
            echo "NOTE: Userland proxy is NOT disabled in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

>>>'###'
# Function to check if userland proxy is disabled via Docker daemon command line
check_userland_proxy_command_line() {
    # Look for Docker daemon process
    local docker_pid=$(pgrep -f dockerd)
    
    if [[ -z "$docker_pid" ]]; then
        echo "NOTE: Docker daemon is not running or could not be found."
        return
    fi

    # Check the command line arguments of the Docker daemon process
    echo "Checking Docker daemon command line for userland proxy..."

    # Check for userland-proxy option
    local userland_proxy=$(ps -ef | grep "[d]ockerd" | grep -oP '(?<=--userland-proxy=)[^ ]+')

    if [[ "$userland_proxy" == "false" ]]; then
        echo "Userland proxy is disabled via command line."
    else
        echo "NOTE: Userland proxy is NOT disabled in the Docker daemon command line."
    fi
}
###
# Call the functions to check userland proxy configuration
check_userland_proxy_config_file
#check_userland_proxy_command_line
