#!/bin/bash

# Function to ensure containerd socket file ownership is set to root:root
ensure_containerd_socket_ownership() {
    containerd_socket_file="/run/containerd/containerd.sock"

    # Check if the containerd socket file exists
    if [[ ! -S "$containerd_socket_file" ]]; then
        echo "Containerd socket file does not exist at $containerd_socket_file."
        return 1  # FAIL
    fi

    # Check the current ownership of the containerd socket file
    current_owner=$(stat -c "%U:%G" "$containerd_socket_file")

    if [[ "$current_owner" == "root:root" ]]; then
        echo "Containerd socket file ownership is already set to root:root."
        return 0  # PASS
    else
        echo "Setting containerd socket file ownership to root:root..."
        if chown root:root "$containerd_socket_file"; then
            echo "Containerd socket file ownership set to root:root successfully."
            return 0  # PASS
        else
            echo "Failed to set containerd socket file ownership to root:root."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_containerd_socket_ownership
