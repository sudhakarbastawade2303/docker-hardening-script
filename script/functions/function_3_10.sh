#!/bin/bash

# Path to the TLS CA certificate file
TLS_CA_CERT_PATH="/etc/docker/certs.d/ca.crt"  # Replace with the actual path

# Desired permissions
desired_permissions="444"

# Initialize a status flag
status=0

# Check if the TLS CA certificate file exists
if [[ -f "$TLS_CA_CERT_PATH" ]]; then
    # Get the current permissions of the file
    current_permissions=$(stat -c "%a" "$TLS_CA_CERT_PATH")

    # Check if the current permissions are more restrictive or equal to the desired permissions
    if [[ "$current_permissions" -le "$desired_permissions" ]]; then
        echo "PASS: The permissions of $TLS_CA_CERT_PATH are correctly set to $current_permissions or more restrictive."
    else
        echo "FAIL: The permissions of $TLS_CA_CERT_PATH are too permissive. Current permissions are $current_permissions."
        status=1
        # # Correct the permissions
        # echo "Changing permissions of $TLS_CA_CERT_PATH to $desired_permissions..."
        # sudo chmod $desired_permissions "$TLS_CA_CERT_PATH"

        # if [[ $? -eq 0 ]]; then
        #     echo "Permissions of $TLS_CA_CERT_PATH successfully changed to $desired_permissions."
        # else
        #     echo "ERROR: Failed to change permissions of $TLS_CA_CERT_PATH."
        #     status=1
        # fi
    fi
else
    echo "FAIL: The TLS CA certificate file $TLS_CA_CERT_PATH does not exist. No action taken."
    status=1
fi

exit $status
