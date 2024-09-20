#!/bin/bash

# Function to ensure /etc/docker directory permissions are set to 755 or more restrictive
ensure_docker_directory_permissions() {
    docker_directory="/etc/docker"
    required_permissions="755"

    # Check if the /etc/docker directory exists
    if [[ ! -d "$docker_directory" ]]; then
        echo "/etc/docker directory does not exist."
        return 1  # FAIL
    fi

    # Check the current permissions of the directory
    current_permissions=$(stat -c "%a" "$docker_directory")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "/etc/docker directory permissions are already $current_permissions (755 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting /etc/docker directory permissions to 755..."
        if chmod 755 "$docker_directory"; then
            echo "/etc/docker directory permissions set to 755 successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/docker directory permissions to 755."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_directory_permissions
