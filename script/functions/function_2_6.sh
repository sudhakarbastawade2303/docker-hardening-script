#!/bin/bash

echo "Checking if AUFS storage driver is being used..."

# Get the current storage driver in use by Docker
storage_driver=$(docker info --format '{{.Driver}}')

# Check if the storage driver is AUFS
if [[ "$storage_driver" == "aufs" ]]; then
    echo "WARNING: AUFS storage driver is currently in use."
    echo "NOTE: It is recommended to use a different storage driver, such as 'overlay2'."
    echo "To change the storage driver, modify the Docker configuration and restart the Docker service."
else
    echo "AUFS storage driver is not in use. Current storage driver: $storage_driver"
fi
