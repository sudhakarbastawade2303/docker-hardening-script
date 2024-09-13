#!/bin/bash

# Function to ensure auditing is configured for /etc/docker directory
ensure_audit_etc_docker() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/docker directory
    local rule_etc_docker="-w /etc/docker -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_etc_docker" "$audit_rules_file"; then
        echo "PASS: Audit rule for /etc/docker is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /etc/docker is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_etc_docker"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_etc_docker
