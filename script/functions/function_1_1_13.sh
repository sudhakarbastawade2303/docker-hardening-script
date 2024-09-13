#!/bin/bash

# Function to ensure auditing is configured for /etc/sysconfig/docker file
ensure_audit_sysconfig_docker() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/sysconfig/docker file
    local rule_sysconfig_docker="-w /etc/sysconfig/docker -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_sysconfig_docker" "$audit_rules_file"; then
        echo "PASS: Audit rule for /etc/sysconfig/docker is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /etc/sysconfig/docker is not configured." 
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_sysconfig_docker" 
        echo "After adding rule restart audit with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_sysconfig_docker
