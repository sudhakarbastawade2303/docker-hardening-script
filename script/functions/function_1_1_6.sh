#!/bin/bash

# Function to ensure auditing is configured for /etc/docker directory
ensure_audit_etc_docker() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/docker directory
    local rule_etc_docker="-w /etc/docker -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_etc_docker" "$audit_rules_file"; then
        echo "Audit rule for /etc/docker is already configured."
    else
        echo "NOTE: Audit rule for /etc/docker is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_etc_docker"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_etc_docker

