#!/bin/bash

# Function to ensure auditing is configured for /var/lib/docker
ensure_audit_docker_directory() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /var/lib/docker
    local rule_docker_dir="-w /var/lib/docker -p wa -k docker"

    # Initialize the status as pass
    local status=0

    # Check if the audit rule for /var/lib/docker is already present
    if grep -q -- "$rule_docker_dir" "$audit_rules_file"; then
        echo "PASS: Audit rule for /var/lib/docker is already configured."
    else
        echo "FAIL: Audit rule for /var/lib/docker is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_docker_dir"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        status=1
    fi

    # Return the overall status
    return $status
}

# Run the function
ensure_audit_docker_directory
