#!/bin/bash

# Function to ensure auditing is configured for /usr/bin/containerd-shim file
ensure_audit_containerd_shim() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /usr/bin/containerd-shim file
    local rule_containerd_shim="-w /usr/bin/containerd-shim -p x -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_containerd_shim" "$audit_rules_file"; then
        echo "PASS: Audit rule for /usr/bin/containerd-shim is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /usr/bin/containerd-shim is not configured." 
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_containerd_shim"
        echo "After adding the rule, restart the audit daemon with the following command:"
        echo "Then restart the audit daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_containerd_shim
