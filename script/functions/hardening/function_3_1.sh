#!/bin/bash

# Function to ensure docker.service file ownership is root:root
ensure_docker_service_ownership() {
    docker_service_file="/usr/lib/systemd/system/docker.service"

    # Check if the docker.service file exists
    if [[ ! -f "$docker_service_file" ]]; then
        echo "Docker service file does not exist at $docker_service_file."
        return 1  # FAIL
    fi

    # Check the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$docker_service_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "Docker service file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting Docker service file ownership to root:root..."
        if chown root:root "$docker_service_file"; then
            echo "Docker service file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker service file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_service_ownership
