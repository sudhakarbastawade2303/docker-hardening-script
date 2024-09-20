#!/bin/bash

# Function to ensure docker.socket file ownership is set to root:root
ensure_docker_socket_ownership() {
    docker_socket_file="/usr/lib/systemd/system/docker.socket"

    # Check if the docker.socket file exists
    if [[ ! -f "$docker_socket_file" ]]; then
        echo "Docker socket file does not exist at $docker_socket_file."
        return 1  # FAIL
    fi

    # Check the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$docker_socket_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "Docker socket file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting Docker socket file ownership to root:root..."
        if chown root:root "$docker_socket_file"; then
            echo "Docker socket file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker socket file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_socket_ownership
