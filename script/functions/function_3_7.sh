#!/bin/bash

# Path to the directory containing registry certificate files
REGISTRY_NAME="<registry-name>"  # Replace with actual registry name
CERT_DIR_PATH="/etc/docker/certs.d/$REGISTRY_NAME"

# Desired ownership
desired_owner="root:root"

# Check if the directory containing the certificate files exists
if [[ -d "$CERT_DIR_PATH" ]]; then
    # List all certificate files in the directory
    cert_files=$(find "$CERT_DIR_PATH" -type f)

    # Check if there are any certificate files
    if [[ -z "$cert_files" ]]; then
        echo "No certificate files found in $CERT_DIR_PATH."
        exit 0
    else
        # Initialize a status flag
        status=0

        # Process each certificate file
        for cert_file in $cert_files; do
            # Get the current ownership of the file
            current_owner=$(stat -c "%U:%G" "$cert_file")

            # Check if the current ownership matches the desired ownership
            if [[ "$current_owner" == "$desired_owner" ]]; then
                echo "PASS: The ownership of $cert_file is correctly set to $desired_owner."
            else
                echo "FAIL: The ownership of $cert_file is incorrect. Current ownership is $current_owner."
        
                # Uncomment the following lines to correct the ownership
                # echo "Changing ownership of $cert_file to $desired_owner..."
                # sudo chown $desired_owner "$cert_file"

                # if [[ $? -eq 0 ]]; then
                #     echo "Ownership of $cert_file successfully changed to $desired_owner."
                # else
                #     echo "ERROR: Failed to change ownership of $cert_file."
                #     status=1
                # fi

                status=1  # Mark status as failure if any ownership is incorrect
            fi
        done

        exit $status
    fi
else
    echo "FAIL: The directory $CERT_DIR_PATH does not exist. No action taken."
    exit 1
fi
