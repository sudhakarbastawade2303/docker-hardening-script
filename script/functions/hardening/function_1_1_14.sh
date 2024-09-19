#!/bin/bash

# Function to configure auditing for Docker files and directories - /usr/bin/containerd
harden_containerd_bin_auditing() {
    audit_rule="/usr/bin/containerd"
    audit_rule_definition="-w $audit_rule -p wa -k docker"
    audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

    # Check if the audit rule already exists in the consolidated file
    if grep -q -- "$audit_rule_definition" "$audit_rules_file"; then
        echo "Audit rule for /usr/bin/containerd already exists in $audit_rules_file."
        return 0  # PASS
    else
        # Add the audit rule to the current audit session
        echo "Adding audit rule for /usr/bin/containerd..."
        if auditctl -w "$audit_rule" -p wa -k docker; then
            # Persist the audit rule by adding it to the consolidated audit rules file
            if echo "$audit_rule_definition" >> "$audit_rules_file"; then
                echo "Audit rule for /usr/bin/containerd added successfully. Auditd restart required."
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
harden_containerd_bin_auditing



# #!/bin/bash

# # Function to configure auditing for /usr/bin/containerd
# harden_containerd_bin_auditing() {
#     # Path to the containerd binary
#     containerd_bin="/usr/bin/containerd"
#     audit_rule_definition="-w $containerd_bin -p wa -k docker"
#     audit_rules_file="/etc/audit/rules.d/audit.rules"  # Consolidated audit rules file

#     # Check if the containerd binary exists
#     if [[ -e "$containerd_bin" ]]; then
#         # Variable to track overall success
#         overall_status=0

#         # Check if the audit rule already exists
#         if auditctl -l | grep -q -- "$audit_rule_definition"; then
#             echo "Audit rule for $containerd_bin already exists."
#             return 0  # PASS - Audit rule exists
#         else
#             # Add the audit rule to the current audit session
#             echo "Adding audit rule for $containerd_bin..."
#             if ! auditctl -w "$containerd_bin" -k docker -p wa; then
#                 echo "Failed to add audit rule to the current audit session."
#                 overall_status=1  # Set status to FAIL
#             else
#                 # Persist the audit rule by adding it to /etc/audit/rules.d/audit.rules
#                 if ! echo "$audit_rule_definition" >> "$audit_rules_file"; then
#                     echo "Failed to persist audit rule."
#                     overall_status=1  # Set status to FAIL
#                 else
#                     # Mark auditd for restart at the end of the hardening process
#                     echo "Audit rule for $containerd_bin added successfully. Auditd restart required."
#                     touch /tmp/auditd_restart_required
#                 fi
#             fi
#         fi
#     else
#         echo "$containerd_bin does not exist. Recommendation does not apply."
#         return 1  # FAIL - File doesn't exist
#     fi

#     return $overall_status
# }

# # Call the function and capture the return status
# harden_containerd_bin_auditing
