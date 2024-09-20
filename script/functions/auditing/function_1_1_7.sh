#!/bin/bash

# Function to ensure auditing is configured for docker.service file
ensure_audit_docker_service() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for docker.service file
    local rule_docker_service="-w /lib/systemd/system/docker.service -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_docker_service" "$audit_rules_file"; then
        echo "PASS: Audit rule for docker.service is already configured."
        return 0
    else
        echo "FAIL: Audit rule for docker.service is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_docker_service"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_docker_service
