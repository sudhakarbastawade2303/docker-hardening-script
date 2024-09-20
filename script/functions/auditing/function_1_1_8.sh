#!/bin/bash

# Function to ensure auditing is configured for containerd.sock file
ensure_audit_containerd_sock() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for containerd.sock file
    local rule_containerd_sock="-w /run/containerd/containerd.sock -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_containerd_sock" "$audit_rules_file"; then
        echo "PASS: Audit rule for containerd.sock is already configured."
        return 0
    else
        echo "FAIL: Audit rule for containerd.sock is not configured."
        echo "NOTE: If file exist, then only add the rule to $audit_rules_file:"
        echo "$rule_containerd_sock"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_containerd_sock
