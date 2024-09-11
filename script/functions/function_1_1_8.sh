#!/bin/bash

# Function to ensure auditing is configured for containerd.sock file
ensure_audit_containerd_sock() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for containerd.sock file
    local rule_containerd_sock="-w /run/containerd/containerd.sock -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q "$rule_containerd_sock" "$audit_rules_file"; then
        echo "Audit rule for containerd.sock is already configured."
    else
        echo "NOTE: Audit rule for containerd.sock is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_containerd_sock"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_containerd_sock

