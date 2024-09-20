#!/bin/bash

# Function to ensure the Docker socket file ownership is set to root:docker
ensure_docker_socket_ownership() {
    docker_socket_file="/var/run/docker.sock"  # Path to the Docker socket file

    # Check if the Docker socket file exists
    if [[ ! -e "$docker_socket_file" ]]; then
        echo "Docker socket file does not exist at $docker_socket_file."
        return 1  # FAIL
    fi

    # Get the current ownership of the socket file
    current_owner=$(stat -c "%U:%G" "$docker_socket_file")

    if [[ "$current_owner" == "root:docker" ]]; then
        echo "Docker socket file ownership is already set to root:docker."
        return 0  # PASS
    else
        echo "Setting Docker socket file ownership to root:docker..."
        if chown root:docker "$docker_socket_file"; then
            echo "Docker socket file ownership set to root:docker successfully."
            return 0  # PASS
        else
            echo "Failed to set Docker socket file ownership to root:docker."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_docker_socket_ownership
