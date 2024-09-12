#!/bin/bash

echo "Checking if Docker daemon logging level is set to 'info'..."

# Define the Docker daemon configuration file path
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

# Check if the logging level is configured in the Docker daemon configuration file
if grep -q '"log-level": *"info"' "$DOCKER_CONFIG_FILE"; then
    echo "Docker daemon logging level is correctly set to 'info'."
else
    echo "NOTE: Docker daemon logging level is not set to 'info'."
    echo "To set the logging level to 'info', add or modify the following entry in $DOCKER_CONFIG_FILE:"
    echo '{'
    echo '  "log-level": "info"'
    echo '}'
    echo "After making the change, restart the Docker daemon using 'sudo systemctl restart docker' or 'sudo service docker restart'."
fi
