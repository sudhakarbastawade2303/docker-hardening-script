#!/bin/bash

# Path to the directory containing registry certificate files
REGISTRY_NAME="<registry-name>"  # Replace with actual registry name
CERT_DIR_PATH="/etc/docker/certs.d/$REGISTRY_NAME"

# Desired permissions
desired_permissions="444"

# Initialize a status flag
status=0

# Check if the directory containing the certificate files exists
if [[ -d "$CERT_DIR_PATH" ]]; then
    # List all certificate files in the directory
    cert_files=$(find "$CERT_DIR_PATH" -type f)

    # Check if there are any certificate files
    if [[ -z "$cert_files" ]]; then
        echo "No certificate files found in $CERT_DIR_PATH."
        exit 0
    else
        # Process each certificate file
        for cert_file in $cert_files; do
            # Get the current permissions of the file
            current_permissions=$(stat -c "%a" "$cert_file")

            # Check if the current permissions are more restrictive or equal to the desired permissions
            if [[ "$current_permissions" -le "$desired_permissions" ]]; then
                echo "PASS: The permissions of $cert_file are correctly set to $current_permissions or more restrictive."
            else
                echo "NOTE: The permissions of $cert_file are too permissive. Current permissions are $current_permissions."
                status=1
                # # Correct the permissions
                # echo "Changing permissions of $cert_file to $desired_permissions..."
                # sudo chmod $desired_permissions "$cert_file"

                # if [[ $? -eq 0 ]]; then
                #     echo "Permissions of $cert_file successfully changed to $desired_permissions."
                # else
                #     echo "ERROR: Failed to change permissions of $cert_file."
                #     status=1
                # fi
            fi
        done
    fi
else
    echo "FAIL: The directory $CERT_DIR_PATH does not exist. No action taken."
    status=1
fi

exit $status
