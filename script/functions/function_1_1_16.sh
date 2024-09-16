#!/bin/bash

# Function to ensure auditing is configured for /usr/bin/containerd-shim-runc-v1 file
ensure_audit_containerd_shim_runc_v1() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /usr/bin/containerd-shim-runc-v1 file
    local rule_containerd_shim_runc_v1="-w /usr/bin/containerd-shim-runc-v1 -p x -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_containerd_shim_runc_v1" "$audit_rules_file"; then
        echo "PASS: Audit rule for /usr/bin/containerd-shim-runc-v1 is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /usr/bin/containerd-shim-runc-v1 is not configured."
        echo "To manually configure the audit rule, add the following line to $audit_rules_file:"
        echo "$rule_containerd_shim_runc_v1"
        echo "After adding the rule, restart the audit daemon with:"
        echo "systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_containerd_shim_runc_v1
