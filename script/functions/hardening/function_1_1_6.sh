#!/bin/bash

# Function to configure auditing for Docker files and directories under /etc/docker
harden_docker_config_auditing() {
    audit_rule="/etc/docker"
    audit_rule_definition="-w $audit_rule -p wa -k docker"
    audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

    # Variable to track overall success
    overall_status=0

    # Check if the audit rule already exists
    if auditctl -l | grep -q -- "$audit_rule_definition"; then
        echo "Audit rule for /etc/docker already exists."
    else
        # Add the audit rule to the current audit session
        echo "Adding audit rule for /etc/docker..."
        if ! auditctl -w "$audit_rule" -p wa -k docker; then
            echo "Failed to add audit rule to the current audit session."
            overall_status=1  # Set status to fail
        else
            # Persist the audit rule by adding it to /etc/audit/rules.d/
            if ! echo "$audit_rule_definition" >> "$audit_rules_file"; then
                echo "Failed to persist audit rule."
                overall_status=1  # Set status to fail
            else
                # Mark auditd for restart at the end of the hardening process
                echo "Audit rule for /etc/docker added successfully. Auditd restart required."
                touch /tmp/auditd_restart_required
            fi
        fi
    fi

    return $overall_status
}

# Call the function and capture the return status
harden_docker_config_auditing

