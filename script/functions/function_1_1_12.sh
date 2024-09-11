#!/bin/bash

# Function to ensure auditing is configured for /etc/containerd/config.toml file
ensure_audit_containerd_config() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/containerd/config.toml file
    local rule_containerd_config="-w /etc/containerd/config.toml -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q "$rule_containerd_config" "$audit_rules_file"; then
        echo "Audit rule for /etc/containerd/config.toml is already configured."
    else
        echo "NOTE: Audit rule for /etc/containerd/config.toml is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_containerd_config"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_containerd_config
