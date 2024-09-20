#!/bin/bash

# Function to ensure docker.service file permissions are appropriately set
ensure_docker_service_permissions() {
    docker_service_file="/usr/lib/systemd/system/docker.service"
    required_permissions="644"

    # Check if the docker.service file exists
    if [[ ! -f "$docker_service_file" ]]; then
        echo "Docker service file does not exist at $docker_service_file."
        return 1  # FAIL
    fi

    # Check the current permissions of the file
    current_permissions=$(stat -c "%a" "$docker_service_file")

    if [[ "$current_permissions" == "$required_permissions" ]]; then
        echo "Docker service file permissions are already set to $required_permissions."
        return 0  # PASS
    else
        echo "Setting Docker service file permissions to $required_permissions..."
        if chmod "$required_permissions" "$docker_service_file"; then
            echo "Docker service file permissions set to $required_permissions successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker service file permissions to $required_permissions."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_service_permissions
