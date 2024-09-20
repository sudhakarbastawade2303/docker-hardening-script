#!/bin/bash

# Function to ensure /etc/sysconfig/docker file permissions are set to 644 or more restrictive
ensure_sysconfig_docker_file_permissions() {
    sysconfig_docker_file="/etc/sysconfig/docker"
    required_permissions="644"

    # Check if the /etc/sysconfig/docker file exists
    if [[ ! -f "$sysconfig_docker_file" ]]; then
        echo "/etc/sysconfig/docker file does not exist."
        return 1  # FAIL
    fi

    # Check the current permissions of the file
    current_permissions=$(stat -c "%a" "$sysconfig_docker_file")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "/etc/sysconfig/docker file permissions are already $current_permissions (644 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting /etc/sysconfig/docker file permissions to 644..."
        if chmod 644 "$sysconfig_docker_file"; then
            echo "/etc/sysconfig/docker file permissions set to 644 successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/sysconfig/docker file permissions to 644."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_sysconfig_docker_file_permissions
