#!/bin/bash

echo "Checking if Docker daemon is running as a non-root user..."

# Get the user running the Docker daemon process
docker_user=$(ps -fe | grep 'dockerd' | grep -v 'grep' | awk '{print $1}')

# Check if the Docker daemon is running as root
if [ "$docker_user" == "root" ]; then
    echo "FAIL: Docker daemon is running as the root user. It is recommended to run the Docker daemon as a non-root user to enhance security."
    return 1
else
    echo "Docker daemon is running as user: $docker_user"
    echo "PASS: The Docker daemon is running with reduced privileges, which is a good security practice."
    return 0
fi
