#!/bin/bash

# Function to configure auditing for the Docker daemon
harden_docker_daemon_auditing() {
    audit_rule="/usr/bin/dockerd"
    audit_rule_definition="-w $audit_rule -p wa -k docker"
    audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

    # Check if the audit rule already exists
    if auditctl -l | grep -q -- "$audit_rule_definition"; then
        echo "Audit rule for Docker daemon already exists."
        return 0  # PASS
    else
        # Add the audit rule to the current audit session
        echo "Adding audit rule for Docker daemon..."
        if auditctl -w "$audit_rule" -p wa -k docker; then
            # Persist the audit rule by adding it to /etc/audit/rules.d/
            if echo "$audit_rule_definition" >> "$audit_rules_file"; then
                echo "Audit rule for Docker daemon added successfully. Auditd restart required."
                touch /tmp/auditd_restart_required
                return 0  # PASS
            else
                echo "Failed to persist audit rule."
                return 1  # FAIL
            fi
        else
            echo "Failed to add audit rule to the current audit session."
            return 1  # FAIL
        fi
    fi
}

# Call the function
harden_docker_daemon_auditing

