#!/bin/bash

# Function to ensure auditing is configured for docker.sock file
ensure_audit_docker_sock() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for docker.sock file
    local rule_docker_sock="-w /var/run/docker.sock -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_docker_sock" "$audit_rules_file"; then
        echo "PASS: Audit rule for docker.sock is already configured."
        return 0
    else
        echo "FAIL: Audit rule for docker.sock is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_docker_sock"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_docker_sock
