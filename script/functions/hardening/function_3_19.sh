#!/bin/bash

# Function to ensure /etc/default/docker file ownership is set to root:root
ensure_docker_default_file_ownership() {
    docker_default_file="/etc/default/docker"
    
    # Check if the /etc/default/docker file exists
    if [[ ! -f "$docker_default_file" ]]; then
        echo "/etc/default/docker file does not exist."
        return 1  # FAIL
    fi

    # Check the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$docker_default_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "/etc/default/docker file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting /etc/default/docker file ownership to root:root..."
        if chown root:root "$docker_default_file"; then
            echo "/etc/default/docker file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set /etc/default/docker file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_default_file_ownership
