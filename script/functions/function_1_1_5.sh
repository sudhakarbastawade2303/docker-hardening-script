#!/bin/bash

# Function to ensure auditing is configured for /var/lib/docker
ensure_audit_docker_directory() {
    local audit_rules_file="/etc/audit/rules.d/audit.rules"
    
    # Audit rule lines
    local rule_docker_dir="-a always,exit -F path=/var/lib/docker -F perm=war -k docker"
    local rule_exclude_volumes="-a never,exit -F dir=/var/lib/docker/volumes"
    local rule_exclude_overlay="-a never,exit -F dir=/var/lib/docker/overlay2"

    # Check if the audit rules are already present
    if grep -q "$rule_docker_dir" "$audit_rules_file"; then
        echo "Audit rule for /var/lib/docker is already configured."
    else
        echo "NOTE: Audit rule for /var/lib/docker is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_docker_dir"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi

    if grep -q "$rule_exclude_volumes" "$audit_rules_file"; then
        echo "Exclusion rule for /var/lib/docker/volumes is already configured."
    else
        echo "NOTE: Exclusion rule for /var/lib/docker/volumes is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_exclude_volumes"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi

    if grep -q "$rule_exclude_overlay" "$audit_rules_file"; then
        echo "Exclusion rule for /var/lib/docker/overlay2 is already configured."
    else
        echo "NOTE: Exclusion rule for /var/lib/docker/overlay2 is not configured. You need to add the following rule to $audit_rules_file:"
        echo "$rule_exclude_overlay"
        echo "After adding rule, restart Audit Daemon with: sudo systemctl restart auditd"
    fi
}

# Run the function
ensure_audit_docker_directory
