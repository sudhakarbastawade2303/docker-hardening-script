#!/bin/bash

# Function to check "Ensure only trusted users are allowed to control Docker daemon"
check_trusted_users_docker_daemon() {
    echo "Checking 1.1.2: Ensure only trusted users are allowed to control Docker daemon"

    # Define your list of trusted users (this should be customized to your environment)
    trusted_users=("root" "ubuntu" "xyz")  # Replace with your actual trusted usernames

    # Get the list of users in the Docker group
    docker_group_users=$(getent group docker | awk -F: '{print $4}' | tr ',' ' ')

    # Check for any untrusted users
    untrusted_found=false
    for user in $docker_group_users; do
        if [[ ! " ${trusted_users[@]} " =~ " ${user} " ]]; then
            echo "FAIL: Untrusted user '$user' found in the Docker group."
            untrusted_found=true
        fi
    done

    # If no untrusted users were found, print PASS
    if [ "$untrusted_found" = false ]; then
        echo "PASS: No untrusted users found in the Docker group."
        return 0  # Indicate success
    else
        echo "NOTE: Review and remove any untrusted users from the Docker group."
        return 1  # Indicate failure
    fi
}

# Main execution
check_trusted_users_docker_daemon
