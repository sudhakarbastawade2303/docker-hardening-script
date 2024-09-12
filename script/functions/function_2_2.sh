#!/bin/bash

echo "Checking if inter-container communication (ICC) is restricted..."

# Define the Docker daemon configuration file path
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

# Check if the icc setting is configured in the Docker daemon configuration file
if grep -q '"icc": *false' "$DOCKER_CONFIG_FILE"; then
    echo "Inter-container communication (ICC) is restricted on the default bridge network."
else
    echo "NOTE: Inter-container communication (ICC) is not restricted on the default bridge network."
    echo "To restrict ICC, add or modify the following entry in $DOCKER_CONFIG_FILE:"
    echo '{'
    echo '  "icc": false'
    echo '}'
    echo "After making the change, restart the Docker daemon using 'sudo systemctl restart docker' or 'sudo service docker restart'."
fi
