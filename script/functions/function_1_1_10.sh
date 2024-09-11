#!/bin/bash

# Function to ensure auditing is configured for /etc/default/docker file
ensure_audit_etc_default_docker() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/default/docker file
    local rule_etc_default_docker="-w /etc/default/docker -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_etc_default_docker" "$audit_rules_file"; then
        echo "Audit rule for /etc/default/docker is already configured."
    else
        echo "NOTE: Audit rule for /etc/default/docker is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_etc_default_docker"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_etc_default_docker
