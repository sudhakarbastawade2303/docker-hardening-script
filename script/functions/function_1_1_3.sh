#!/bin/bash

# Function to check if auditing is configured for Docker daemon
check_docker_audit() {
    audit_rule="-w /usr/bin/dockerd -k docker"

    echo "Checking if auditing is configured for Docker daemon..."

    # Check current audit rules
    if auditctl -l | grep -q "$audit_rule"; then
        echo "Auditing is configured for Docker daemon."
        return 0
    else
        echo "Auditing is NOT configured for Docker daemon."
        echo "NOTE: To configure auditing, add the following rule to your audit rules file:"
        echo "Add the following line to /etc/audit/rules.d/audit.rules (for systems using auditd)"
        echo "$audit_rule"
        echo "Then restart the audit daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Call the function
check_docker_audit

