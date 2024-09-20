#!/bin/bash

# Function to ensure Docker socket file permissions are set to 660 or more restrictively
ensure_docker_socket_permissions() {
    docker_socket_file="/var/run/docker.sock"
    required_permissions="660"

    # Check if the Docker socket file exists
    if [[ ! -e "$docker_socket_file" ]]; then
        echo "Docker socket file does not exist."
        return 1  # FAIL
    fi

    # Check the current permissions of the socket file
    current_permissions=$(stat -c "%a" "$docker_socket_file")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "Docker socket file permissions are already $current_permissions (660 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting Docker socket file permissions to 660..."
        if chmod 660 "$docker_socket_file"; then
            echo "Docker socket file permissions set to 660 successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker socket file permissions to 660."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_socket_permissions
