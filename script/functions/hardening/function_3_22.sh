#!/bin/bash

# Function to ensure /etc/sysconfig/docker file ownership is set to root:root
ensure_sysconfig_docker_file_ownership() {
    sysconfig_docker_file="/etc/sysconfig/docker"

    # Check if the /etc/sysconfig/docker file exists
    if [[ ! -f "$sysconfig_docker_file" ]]; then
        echo "/etc/sysconfig/docker file does not exist."
        return 1  # FAIL
    fi

    # Check the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$sysconfig_docker_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "/etc/sysconfig/docker file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting /etc/sysconfig/docker file ownership to root:root..."
        if chown root:root "$sysconfig_docker_file"; then
            echo "/etc/sysconfig/docker file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/sysconfig/docker file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_sysconfig_docker_file_ownership
