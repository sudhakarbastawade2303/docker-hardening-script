
#!/bin/bash

check_insecure_registries() {
    echo "Checking for insecure registries in Docker configuration..."

    # Define the Docker daemon configuration file path
    DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

    # Check if the "insecure-registries" option is configured in the Docker daemon configuration file
    if grep -q '"insecure-registries":' "$DOCKER_CONFIG_FILE"; then
        # Extract the insecure registries
        insecure_registries=$(grep -oP '"insecure-registries": *\[[^\]]*' "$DOCKER_CONFIG_FILE")

        echo "FAIL: Insecure registries are configured:"
        echo "$insecure_registries"
        echo "To remove the insecure registries, open $DOCKER_CONFIG_FILE and remove or comment out the 'insecure-registries' section."
        echo "After making the change, restart the Docker daemon using 'sudo systemctl restart docker' or 'sudo service docker restart'."
        return 1
    else
        echo "PASS: No insecure registries are configured in Docker."
        return 0
    fi
}

# Call the function
check_insecure_registries
