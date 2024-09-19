#!/bin/bash

# Function to configure auditing for docker.sock
harden_docker_sock_auditing() {
    # Step 1: Find the configuration file location for docker.sock
    config_file_path=$(systemctl show -p FragmentPath docker.socket | sed 's/FragmentPath=//')

    # Check if the configuration file was found
    if [[ -n "$config_file_path" && -f "$config_file_path" ]]; then
        # Step 2: Extract the socket file path using grep
        socket_file_path=$(grep ListenStream "$config_file_path" | awk '{print $2}')

        if [[ -n "$socket_file_path" && -e "$socket_file_path" ]]; then
            # Step 3: Define the audit rule
            audit_rule="$socket_file_path"
            audit_rule_definition="-w $audit_rule -k docker"
            audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

            # Variable to track overall success
            overall_status=0

            # Step 4: Check if the audit rule already exists
            if auditctl -l | grep -q -- "$audit_rule_definition"; then
                echo "Audit rule for docker.sock already exists."
            else
                # Add the audit rule to the current audit session
                echo "Adding audit rule for docker.sock..."
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
                        echo "Audit rule for docker.sock added successfully. Auditd restart required."
                        touch /tmp/auditd_restart_required
                    fi
                fi
            fi
        else
            echo "docker.sock not found at $socket_file_path. Recommendation does not apply."
            overall_status=1  # Set status to fail if the file is not found
        fi
    else
        echo "docker.socket configuration file not found or does not exist at $config_file_path."
        overall_status=1  # Set status to fail if config file is not found
    fi

    return $overall_status
}

# Call the function and capture the return status
harden_docker_sock_auditing
