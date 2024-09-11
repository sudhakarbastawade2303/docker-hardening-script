#!/bin/bash

# Function to ensure auditing is configured for /usr/bin/containerd file
ensure_audit_containerd() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /usr/bin/containerd file
    local rule_containerd="-w /usr/bin/containerd -p x -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_containerd" "$audit_rules_file"; then
        echo "Audit rule for /usr/bin/containerd is already configured."
    else
        echo "NOTE: Audit rule for /usr/bin/containerd is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_containerd"
        echo "After adding the rule, restart the audit daemon with the following command:"
        echo "Then restart the audit daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_containerd
