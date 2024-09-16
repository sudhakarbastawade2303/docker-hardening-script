#!/bin/bash

# Function to check if a custom seccomp profile is applied using docker info
check_seccomp_profile_docker_info() {
    echo "Checking Docker daemon for seccomp profile using docker info..."

    # Run docker info and capture the output
    docker_info_output=$(docker info 2>/dev/null)

    # Check if the docker info command was successful
    if [[ $? -ne 0 ]]; then
        echo "FAIL: Docker is not running or the docker command failed."
        return 1
    fi

    # Search for seccomp profile information in the docker info output
    if echo "$docker_info_output" | grep -q "seccomp"; then
        if echo "$docker_info_output" | grep -q "default"; then
            echo "NOTE: Default seccomp profile is in use."
            return 0
        else
            echo "PASS: Custom seccomp profile information found in Docker info output:"
            echo "$docker_info_output" | grep "seccomp"
            return 0
        fi
    else
        echo "FAIL: Seccomp profile information is NOT present in the Docker info output."
        return 1
    fi
}

# Call the function to check seccomp profile configuration
check_seccomp_profile_docker_info
