#!/bin/bash

# Function to configure auditing for Docker files and directories - /var/lib/docker
harden_docker_files_auditing() {
    audit_rule="/var/lib/docker"
    audit_rule_definition="-w $audit_rule -p wa -k docker"
    audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

    # Check if the audit rule already exists in the consolidated file
    if grep -q -- "$audit_rule_definition" "$audit_rules_file"; then
        echo "Audit rule for /var/lib/docker already exists in $audit_rules_file."
        return 0  # PASS
    else
        # Add the audit rule to the current audit session
        echo "Adding audit rule for /var/lib/docker..."
        if auditctl -w "$audit_rule" -p wa -k docker; then
            # Persist the audit rule by adding it to the consolidated audit rules file
            if echo "$audit_rule_definition" >> "$audit_rules_file"; then
                echo "Audit rule for /var/lib/docker added successfully. Auditd restart required."
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
harden_docker_files_auditing



# #!/bin/bash

# # Function to configure auditing for Docker files and directories under /var/lib/docker
# function harden_docker_files_auditing() {
#     # Define the audit rule for /var/lib/docker
#     audit_rule="-w /var/lib/docker -p wa -k docker"
#     audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

#     # Variable to track overall success
#     overall_status=0

#     # Check if the audit rule already exists
#     if auditctl -l | grep -q -- "$audit_rule"; then
#         echo "Audit rule for /var/lib/docker already exists."
#     else
#         # Add the audit rule to the current audit session
#         echo "Adding audit rule: $audit_rule"
#         if ! auditctl -w /var/lib/docker -p wa -k docker; then
#             echo "Failed to add audit rule: $audit_rule"
#             overall_status=1  # Set status to fail
#         else
#             # Mark auditd for restart at the end of the hardening process
#             echo "Audit rule for /var/lib/docker added successfully. Auditd restart required."
#             touch /tmp/auditd_restart_required
#         fi
#     fi

#     # Persist the audit rule by adding it to /etc/audit/rules.d/
#     if ! grep -q -- "$audit_rule" "$audit_rules_file"; then
#         if ! echo "$audit_rule" >> "$audit_rules_file"; then
#             echo "Failed to persist audit rule: $audit_rule"
#             overall_status=1  # Set status to fail
#         fi
#     fi

#     return $overall_status
# }

# # Call the function and capture the return status
# harden_docker_files_auditing

# ###