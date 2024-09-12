#!/bin/bash

echo "Checking if Docker daemon is running as a non-root user..."

# Get the user running the Docker daemon process
docker_user=$(ps -fe | grep 'dockerd' | grep -v 'grep' | awk '{print $1}')

# Check if the Docker daemon is running as root
if [ "$docker_user" == "root" ]; then
    echo "NOTE: Docker daemon is running as the root user. It is recommended to run the Docker daemon as a non-root user to enhance security."
else
    echo "Docker daemon is running as user: $docker_user"
    echo "The Docker daemon is running with reduced privileges, which is a good security practice."
fi
