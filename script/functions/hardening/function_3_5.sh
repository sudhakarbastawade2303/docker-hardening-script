#!/bin/bash

# Function to ensure /etc/docker directory ownership is set to root:root
ensure_docker_directory_ownership() {
    docker_directory="/etc/docker"

    # Check if the /etc/docker directory exists
    if [[ ! -d "$docker_directory" ]]; then
        echo "/etc/docker directory does not exist."
        return 1  # FAIL
    fi

    # Check the current ownership of the directory
    current_owner=$(stat -c "%U:%G" "$docker_directory")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "/etc/docker directory ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting /etc/docker directory ownership to root:root..."
        if chown root:root "$docker_directory"; then
            echo "/etc/docker directory ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/docker directory ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_directory_ownership
