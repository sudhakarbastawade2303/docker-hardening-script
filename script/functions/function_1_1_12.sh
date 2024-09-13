#!/bin/bash

# Function to ensure auditing is configured for /etc/containerd/config.toml file
ensure_audit_containerd_config() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/containerd/config.toml file
    local rule_containerd_config="-w /etc/containerd/config.toml -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_containerd_config" "$audit_rules_file"; then
        echo "PASS: Audit rule for /etc/containerd/config.toml is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /etc/containerd/config.toml is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_containerd_config"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_containerd_config
