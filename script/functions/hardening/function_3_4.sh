#!/bin/bash

# Function to ensure docker.socket file permissions are set to 644
ensure_docker_socket_permissions() {
    docker_socket_file="/usr/lib/systemd/system/docker.socket"

    # Check if the docker.socket file exists
    if [[ ! -f "$docker_socket_file" ]]; then
        echo "Docker socket file does not exist at $docker_socket_file."
        return 1  # FAIL
    fi

    # Check the current permissions of the file
    current_permissions=$(stat -c "%a" "$docker_socket_file")

    if [[ "$current_permissions" == "644" ]]; then
        echo "Docker socket file permissions are already set to 644."
        return 0  # PASS
    else
        echo "Setting Docker socket file permissions to 644..."
        if chmod 644 "$docker_socket_file"; then
            echo "Docker socket file permissions set to 644 successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker socket file permissions to 644."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_socket_permissions
