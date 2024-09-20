#!/bin/bash

# Function to ensure /etc/default/docker file permissions are set to 644 or more restrictive
ensure_docker_default_file_permissions() {
    docker_default_file="/etc/default/docker"
    required_permissions="644"

    # Check if the /etc/default/docker file exists
    if [[ ! -f "$docker_default_file" ]]; then
        echo "/etc/default/docker file does not exist."
        return 1  # FAIL
    fi

    # Check the current permissions of the file
    current_permissions=$(stat -c "%a" "$docker_default_file")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "/etc/default/docker file permissions are already $current_permissions (644 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting /etc/default/docker file permissions to 644..."
        if chmod 644 "$docker_default_file"; then
            echo "/etc/default/docker file permissions set to 644 successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/default/docker file permissions to 644."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_default_file_permissions
