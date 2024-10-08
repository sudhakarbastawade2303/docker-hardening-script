#!/bin/bash

# Function to check if auditing is configured for /run/containerd
check_audit_rule() {
    local path="/run/containerd"
    local rule="-w /run/containerd -p wa -k docker"

    echo "Checking: Ensure auditing is configured for $path..."

    # Check if the audit rule exists
    if auditctl -l | grep -q -- "$rule"; then
        echo "PASS: Auditing is configured for $path."
        return 0  # Indicates pass
    else
        echo "FAIL: Auditing is NOT configured for $path."
        echo "NOTE: To configure auditing for $path, perform the following steps:"
        echo "1. Open the audit rules file (e.g., /etc/audit/rules.d/audit.rules) in a text editor."
        echo "2. Add the following line:"
        echo "   $rule"
        echo "3. Save the file and restart the audit daemon with: sudo systemctl restart auditd"
        return 1  # Indicates fail
    fi
}

# Call the function to check the audit rule
check_audit_rule
