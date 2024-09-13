#!/bin/bash

# Function to ensure auditing is configured for /usr/bin/runc file
ensure_audit_runc() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule line for /usr/bin/runc file
    local rule_runc="-w /usr/bin/runc -p x -k docker"

    # Check if the audit rule is already present
    if grep -q -- "$rule_runc" "$audit_rules_file"; then
        echo "PASS: Audit rule for /usr/bin/runc is already configured."
        return 0
    else
        echo "FAIL: Audit rule for /usr/bin/runc is not configured."
        echo "To configure the audit rule, add the following line to $audit_rules_file:"
        echo "$rule_runc"
        echo "After adding the rule, restart the audit daemon with:"
        echo "systemctl restart auditd"
        return 1
    fi
}

# Run the function
ensure_audit_runc
