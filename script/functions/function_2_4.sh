#!/bin/bash

echo "Checking if Docker is allowed to make changes to iptables..."

# Define the Docker daemon configuration file path
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

# Initialize status variable
STATUS=1

# Check if the iptables option is configured in the Docker daemon configuration file
if grep -q '"iptables": *true' "$DOCKER_CONFIG_FILE"; then
    echo "PASS: Docker is allowed to make changes to iptables."
    STATUS=0
elif grep -q '"iptables": *false' "$DOCKER_CONFIG_FILE"; then
    echo "FAIL: Docker is not allowed to make changes to iptables."
    echo "To allow Docker to make changes to iptables, add or modify the following entry in $DOCKER_CONFIG_FILE:"
    echo '{'
    echo '  "iptables": true'
    echo '}'
    echo "After making the change, restart the Docker daemon using 'sudo systemctl restart docker' or 'sudo service docker restart'."
else
    echo "PASS: Docker is allowed to make changes to iptables by default (no specific configuration found)."
    STATUS=0
fi

# Exit with the status code
exit $STATUS
