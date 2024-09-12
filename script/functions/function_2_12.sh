#!/bin/bash

# Function to check if authorization plugin is configured in the Docker config file
check_docker_auth_config_file() {
    local config_file="/etc/docker/daemon.json"
    local auth_plugin_key="authorization-plugins"

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        # Look for the authorization-plugins key in the Docker config file
        if grep -q "$auth_plugin_key" "$config_file"; then
            echo "Docker client command authorization is configured in $config_file."
        else
            echo "NOTE: Docker client command authorization is NOT configured in $config_file."
        fi
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Function to check if authorization plugin is enabled via Docker daemon command line
check_docker_auth_command_line() {
    # Look for the Docker daemon process
    local docker_pid=$(pgrep -f dockerd)
    
    if [[ -z "$docker_pid" ]]; then
        echo "NOTE: Docker daemon is not running or could not be found."
        return
    fi

    # Check the command line arguments of the Docker daemon process
    local auth_plugins=$(ps -ef | grep "[d]ockerd" | grep -oP '(?<=--authorization-plugins=)[^ ]+')

    if [[ -n "$auth_plugins" ]]; then
        echo "Docker client command authorization is enabled via command line: $auth_plugins"
    else
        echo "NOTE: Docker client command authorization is NOT configured in the Docker daemon command line."
    fi
}

# Call the functions to check Docker client command authorization
check_docker_auth_config_file
check_docker_auth_command_line
