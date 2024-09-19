#!/bin/bash

# Function to configure auditing for Docker files and directories - /etc/default/docker
harden_docker_default_config_auditing() {
    audit_rule="/etc/default/docker"
    audit_rule_definition="-w $audit_rule -p wa -k docker"
    audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

    # Check if the audit rule already exists in the consolidated file
    if grep -q -- "$audit_rule_definition" "$audit_rules_file"; then
        echo "Audit rule for /etc/default/docker already exists in $audit_rules_file."
        return 0  # PASS
    else
        # Add the audit rule to the current audit session
        echo "Adding audit rule for /etc/default/docker..."
        if auditctl -w "$audit_rule" -p wa -k docker; then
            # Persist the audit rule by adding it to the consolidated audit rules file
            if echo "$audit_rule_definition" >> "$audit_rules_file"; then
                echo "Audit rule for /etc/default/docker added successfully. Auditd restart required."
                touch /tmp/auditd_restart_required
                return 0  # PASS
            else
                echo "Failed to persist audit rule in $audit_rules_file."
                return 1  # FAIL
            fi
        else
            echo "Failed to add audit rule to the current audit session."
            return 1  # FAIL
        fi
    fi
}

# Call the function and capture the return status
harden_docker_default_config_auditing




# #!/bin/bash

# # Function to configure auditing for /etc/default/docker
# harden_docker_default_config_auditing() {
#     # Path to the Docker configuration file
#     config_file="/etc/default/docker"
#     audit_rule_definition="-w $config_file -p wa -k docker"
#     audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

#     # Check if the configuration file exists
#     if [[ -e "$config_file" ]]; then
#         # Variable to track overall success
#         overall_status=0

#         # Check if the audit rule already exists
#         if auditctl -l | grep -q -- "$audit_rule_definition"; then
#             echo "Audit rule for $config_file already exists."
#         else
#             # Add the audit rule to the current audit session
#             echo "Adding audit rule for $config_file..."
#             if ! auditctl -w "$config_file" -k docker -p wa; then
#                 echo "Failed to add audit rule to the current audit session."
#                 overall_status=1  # Set status to fail
#             else
#                 # Persist the audit rule by adding it to /etc/audit/rules.d/
#                 if ! echo "$audit_rule_definition" >> "$audit_rules_file"; then
#                     echo "Failed to persist audit rule."
#                     overall_status=1  # Set status to fail
#                 else
#                     # Mark auditd for restart at the end of the hardening process
#                     echo "Audit rule for $config_file added successfully. Auditd restart required."
#                     touch /tmp/auditd_restart_required
#                 fi
#             fi
#         fi
#     else
#         echo "Docker configuration file $config_file does not exist. Recommendation does not apply."
#         return 1  # Fail since the file does not exist
#     fi

#     return $overall_status
# }

# # Call the function and capture the return status
# harden_docker_default_config_auditing
