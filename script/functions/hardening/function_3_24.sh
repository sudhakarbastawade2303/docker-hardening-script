#!/bin/bash

# Function to ensure containerd socket file permissions are set to 660 or more restrictive
ensure_containerd_socket_permissions() {
    containerd_socket_file="/run/containerd/containerd.sock"
    required_permissions="660"

    # Check if the containerd socket file exists
    if [[ ! -S "$containerd_socket_file" ]]; then
        echo "Containerd socket file does not exist at $containerd_socket_file."
        return 1  # FAIL
    fi

    # Check the current permissions of the containerd socket file
    current_permissions=$(stat -c "%a" "$containerd_socket_file")

    if [[ "$current_permissions" -le "$required_permissions" ]]; then
        echo "Containerd socket file permissions are already $current_permissions (660 or more restrictive)."
        return 0  # PASS
    else
        echo "Setting containerd socket file permissions to 660..."
        if chmod 660 "$containerd_socket_file"; then
            echo "Containerd socket file permissions set to 660 successfully."
            return 0  # PASS
        else
            echo "Failed to set containerd socket file permissions to 660."
            return 1  # FAIL
        fi
    fi
}

# Call the function
ensure_containerd_socket_permissions
