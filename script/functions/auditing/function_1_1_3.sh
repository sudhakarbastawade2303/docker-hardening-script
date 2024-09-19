#!/bin/bash

# Function to check if auditing is configured for Docker daemon
check_docker_audit() {
    audit_rule="-w /usr/bin/dockerd -p wa -k docker"

    echo "Checking: Ensure auditing is configured for Docker daemon..."

    # Check current audit rules
    if auditctl -l | grep -q -- "$audit_rule"; then
        echo "PASS: Auditing is configured for Docker daemon."
        return 0  # Indicates pass
    else
        echo "FAIL: Auditing is NOT configured for Docker daemon."
        echo "NOTE: To configure auditing, add the following rule to your audit rules file:"
        echo "      $audit_rule"
        echo "Then restart the audit daemon with: sudo systemctl restart auditd"
        return 1  # Indicates fail
    fi
}

# Call the function
check_docker_audit
