
#!/bin/bash

# Function to check if user namespace support is enabled
check_user_namespace() {
    local config_file="/etc/docker/daemon.json"
    local status=0

    # Check if the config file exists
    if [[ -f "$config_file" ]]; then
        # Look for the userns-remap option in the Docker config file
        if grep -q '"userns-remap"' "$config_file"; then
            echo "User namespace support is configured."
        else
            echo "WARNING: User namespace support is NOT configured in $config_file."
            status=1
        fi
    else
        echo "WARNING: Docker configuration file $config_file does not exist."
        status=1
    fi

    # Return the status code
    return $status
}

# Call the function to check user namespace support
check_user_namespace

# Exit with the status code returned by the function
return $?
