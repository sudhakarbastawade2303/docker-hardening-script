#!/bin/bash

# Function to configure auditing for Docker service file
harden_docker_service_auditing() {
    # Verify if the docker.service file exists
    service_file_path=$(systemctl show -p FragmentPath docker.service | sed 's/FragmentPath=//')

    if [[ -n "$service_file_path" && -f "$service_file_path" ]]; then
        # Define the audit rule
        audit_rule="$service_file_path"
        audit_rule_definition="-w $audit_rule -k docker"
        audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

        # Variable to track overall success
        overall_status=0

        # Check if the audit rule already exists
        if auditctl -l | grep -q -- "$audit_rule_definition"; then
            echo "Audit rule for Docker service file already exists."
        else
            # Add the audit rule to the current audit session
            echo "Adding audit rule for Docker service file..."
            if ! auditctl -w "$audit_rule" -k docker; then
                echo "Failed to add audit rule to the current audit session."
                overall_status=1  # Set status to fail
            else
                # Persist the audit rule by adding it to /etc/audit/rules.d/
                if ! echo "$audit_rule_definition" >> "$audit_rules_file"; then
                    echo "Failed to persist audit rule."
                    overall_status=1  # Set status to fail
                else
                    # Mark auditd for restart at the end of the hardening process
                    echo "Audit rule for Docker service file added successfully. Auditd restart required."
                    touch /tmp/auditd_restart_required
                fi
            fi
        fi
    else
        echo "Docker service file does not exist at $service_file_path. Recommendation does not apply."
        overall_status=1  # Set status to fail if the service file is not found
    fi

    return $overall_status
}

# Call the function and capture the return status
harden_docker_service_auditing
