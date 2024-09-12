#!/bin/bash

# Path to the TLS CA certificate file
TLS_CA_CERT_PATH="/etc/docker/certs.d/ca.crt"  # Replace with the actual path

# Desired ownership
desired_owner="root:root"

# Check if the TLS CA certificate file exists
if [[ -f "$TLS_CA_CERT_PATH" ]]; then
    # Get the current ownership of the file
    current_owner=$(stat -c "%U:%G" "$TLS_CA_CERT_PATH")

    # Check if the current ownership matches the desired ownership
    if [[ "$current_owner" == "$desired_owner" ]]; then
        echo "The ownership of $TLS_CA_CERT_PATH is correctly set to $desired_owner."
    else
        echo "NOTE: The ownership of $TLS_CA_CERT_PATH is incorrect. Current ownership is $current_owner."

        # Correct the ownership
        echo "Changing ownership of $TLS_CA_CERT_PATH to $desired_owner..."
        sudo chown $desired_owner "$TLS_CA_CERT_PATH"

        if [[ $? -eq 0 ]]; then
            echo "Ownership of $TLS_CA_CERT_PATH successfully changed to $desired_owner."
        else
            echo "ERROR: Failed to change ownership of $TLS_CA_CERT_PATH."
        fi
    fi
else
    echo "The TLS CA certificate file $TLS_CA_CERT_PATH does not exist. No action taken."
fi
