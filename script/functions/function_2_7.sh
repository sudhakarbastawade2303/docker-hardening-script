#!/bin/bash

check_tls_configuration() {
    echo "Checking if TLS authentication for Docker daemon is configured..."

    # Check the Docker daemon process for TLS configuration
    tls_configured=$(ps -ef | grep 'dockerd' | grep -E '\-\-tlsverify|\-\-tlscacert|\-\-tlscert|\-\-tlskey')

    if [[ -n "$tls_configured" ]]; then
        echo "PASS: TLS authentication for Docker daemon is configured."
        return 0
    else
        echo "FAIL: TLS authentication for Docker daemon is NOT configured."
        echo "NOTE: It is recommended to configure TLS authentication to secure communication with the Docker daemon."
        echo "You can configure TLS by setting the following flags in the Docker daemon start command or configuration file:"
        echo "--tlsverify --tlscacert=<path to CA certificate> --tlscert=<path to server certificate> --tlskey=<path to server key>"
        return 1
    fi
}

# Call the function
check_tls_configuration
