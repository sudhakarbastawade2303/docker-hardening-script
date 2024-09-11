#!/bin/bash

# Function to ensure auditing is configured for /etc/docker/daemon.json file
ensure_audit_daemon_json() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/docker/daemon.json file
    local rule_daemon_json="-w /etc/docker/daemon.json -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_daemon_json" "$audit_rules_file"; then
        echo "Audit rule for /etc/docker/daemon.json is already configured."
    else
        echo "NOTE: Audit rule for /etc/docker/daemon.json is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_daemon_json"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_daemon_json
