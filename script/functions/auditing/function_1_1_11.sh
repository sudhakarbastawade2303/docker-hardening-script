#!/bin/bash

# Function to ensure auditing is configured for /etc/docker/daemon.json file
ensure_audit_daemon_json() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /etc/docker/daemon.json file
    local rule_daemon_json="-w /etc/docker/daemon.json -p wa -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_daemon_json" "$audit_rules_file"; then
        echo "PASS: Audit rule for /etc/docker/daemon.json is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /etc/docker/daemon.json is not configured."
        echo "NOTE: You need to add the following rule to $audit_rules_file:"
        echo "$rule_daemon_json"
        echo "After adding the rule, restart the Audit Daemon with: sudo systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_daemon_json
