#!/bin/bash

# Function to check if centralized or remote logging is configured in the Docker config file
check_logging_config_file() {
    local config_file="/etc/docker/daemon.json"
    local logging_drivers=("fluentd" "gelf" "syslog")

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        echo "Checking Docker logging configuration in $config_file..."
        
        for driver in "${logging_drivers[@]}"; do
            if grep -q "$driver" "$config_file"; then
                echo "Centralized or remote logging is configured with driver: $driver"
                return
            fi
        done
        
        echo "NOTE: Centralized or remote logging is NOT configured in $config_file."
    else
        echo "NOTE: Docker configuration file $config_file does not exist."
    fi
}

# Function to check if centralized or remote logging is enabled via Docker daemon command line
check_logging_command_line() {
    local logging_drivers=("fluentd" "gelf" "syslog")

    # Look for the Docker daemon process
    local docker_pid=$(pgrep -f dockerd)
    
    if [[ -z "$docker_pid" ]]; then
        echo "NOTE: Docker daemon is not running or could not be found."
        return
    fi

    echo "Checking Docker logging configuration from command line..."

    # Check the command line arguments of the Docker daemon process
    for driver in "${logging_drivers[@]}"; do
        if ps -ef | grep "[d]ockerd" | grep -q "--log-driver=$driver"; then
            echo "Centralized or remote logging is enabled with driver: $driver"
            return
        fi
    done
    
    echo "NOTE: Centralized or remote logging is NOT configured in the Docker daemon command line."
}

# Call the functions to check logging configuration
check_logging_config_file
check_logging_command_line
