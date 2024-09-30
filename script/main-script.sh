#!/bin/bash

total_recommendations=0
skipped_recommendations=0
not_applicable_recommendations=0
excluded_recommendations=0
passed_recommendations=0
remediated_recommendations=0
manual_recommendations=0
failed_recommendations=0

# Get the audit date and server name
audit_date=$(date '+%Y-%m-%d %H:%M:%S')
server_name=$(hostname)

# File paths for reports
audit_report_file="/home/ec2-user/output/audit_report.txt"
hardening_report_file="/home/ec2-user/output/hardening_report.txt"

# Load the exclusion list into an array
exclusions=()
while IFS= read -r line || [[ -n "$line" ]]; do
    exclusions+=("$line")
done < exclusion_list.txt

# Function to check if a control is excluded (applies only to auditing)
is_excluded() {
    local control="$1"
    for excluded in "${exclusions[@]}"; do
        if [[ "$excluded" == "$control" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to get control heading (description)
get_control_heading() {
    local control_number="$1"
    case "$control_number" in
        "1.1.1") echo "Ensure a separate partition for containers has been created(manual)" ;;
        "1.1.2") echo "Ensure only trusted users are allowed to control Docker daemon(manual)" ;;
        "1.1.3") echo "Ensure Auditing is configured for docker daemon(Automated)" ;;
        "1.1.4") echo "Ensure Auditing is configured for docker file and directories - /run/containerd (manual)" ;;
        "1.1.5") echo "Ensure Auditing is configured for docker file and directories - /var/lib/docker (manual)" ;;
        "1.1.6") echo "Ensure Auditing is configured for docker file and directories - /etc/docker (Automated)" ;;
        "1.1.7") echo "Ensure Auditing is configured for docker file and directories -docker.service (Automated)" ;;
        "1.1.8") echo "Ensure Auditing is configured for docker file and directories -containerd.sock (automated)" ;;
        "1.1.9") echo "Ensure Auditing is configured for docker file and directories -docker.sock (automated)" ;;
        "1.1.10") echo "Ensure Auditing is configured for docker file and directories - /etc/default/docker  (automated)" ;;
        "1.1.11") echo "Ensure Auditing is configured for docker file and directories - /etc/docker/daemon.json  (automated)" ;;
        "1.1.12") echo "Ensure Auditing is configured for docker file and directories - /etc/containerd/config.toml (Automated )" ;;
        "1.1.13") echo "Ensure Auditing is configured for docker file and directories - /etc/sysconfig/docker (Automated)" ;;
        "1.1.14") echo "Ensure Auditing is configured for docker file and directories - /usr/bin/containerd (automated)" ;;
        "1.1.15") echo "Ensure Auditing is configured for docker file and directories - /usr/bin/containerd-shim (automated)" ;;
        "1.1.16") echo "Ensure Auditing is configured for docker file and directories - /usr/bin/containerd-shim-runc-v1 (manual)" ;;
        "1.1.17") echo "Ensure Auditing is configured for docker file and directories - /usr/bin/containerd-shim-runc-v2  ( Automated )" ;;
        "1.1.18") echo "Ensure Auditing is configured for docker file and directories - /usr/bin/runc (automated)" ;;
        "1.2.1") echo "Ensure the container Host has been Hardened (manual)" ;;
        "1.2.2") echo "Ensure that the version of docker is up to date (manual)" ;;
        "2.1") echo "Run the docker daemon as non root user,if possible (manual)" ;;
        "2.2") echo "Ensure the network traffic is restricted between containers on the default bridge (manual)" ;;
        "2.3") echo "ensure the logging level set to 'info' (manual)" ;;
        "2.4") echo "Ensure the Docker is allowed to make changes to iptable (manual)" ;;
        "2.5") echo "Ensure the insecure registries are not used (manual)" ;;
        "2.6") echo "ensure aufs storage driver is not used (manual)" ;;
        "2.7") echo "Emsure the TLS authentication for docker daemon is configured (manual)" ;;
        "2.8") echo "Emsure thedefault ulimit is configured appropriatly (manual)" ;;
        "2.9") echo "Enable user namespace support (manual)" ;;
        "2.10") echo "Ensure the default cgroup usage has been confirmed (manual)" ;;
        "2.11") echo "Ensure base device size is not configured utill needed (manual)" ;;
        "2.12") echo "Ensure that authorization for docker client command is enable (manual)" ;;
        "2.13") echo "Ensure that centralised and remote logging is configured (manual)" ;;
        "2.14") echo "Ensure containers are restricted from acquiring new privilages (manual)" ;;
        "2.15") echo "Ensure live restore is enable (manual)" ;;
        "2.16") echo "Ensure user land proxy is Disabled (manual)" ;;
        "2.17") echo "Ensure that a Daemon-wide custom seccomp profile is applied if appropriate  (manual)" ;;
        "2.18") echo "Ensure that experimental features are not implemented in production (manual)" ;;
        "3.1") echo "Ensure that the docker.service file ownership is set to root:root (Automated)" ;;
        "3.2") echo "Ensure that Docker.service file permissions are appropriatly set (Automated)" ;;
        "3.3") echo "Ensure that the docker.socket file ownership is set to root:root (Automated)" ;;
        "3.4") echo "Ensure that docker.socket file permissions  are set to 644 or more restrictive (Automated)" ;;
        "3.5") echo "Ensure that the /etc/docker directory ownership is set to root:root (Automated)" ;;
        "3.6") echo "Ensure that the /etc/docker directory permissions are se to 755 or more restictively  (Automated)" ;;
        "3.7") echo "Ensure that registry certificate file ownership is set to root:root (manual)" ;;
        "3.8") echo "Ensure that registry certificate file permission are set to 444 or more resrictively (manual)" ;;
        "3.9") echo "Ensure that TLS CA certificate file ownership is set to root:root (manual)" ;;
        "3.10") echo "Ensure that TLS CA certificate file permissions are set to 444 or more resrtictively (manual)" ;;
        "3.11") echo "Ensure that docker server certificate file ownership is set to root:root (manual)" ;;
        "3.12") echo "Ensure that docker server certificate file permissions are set to 444 or more restrictively (manual)" ;;
        "3.13") echo "Ensure that docker server certificate key file ownership is set to root:root (manual)" ;;
        "3.14") echo "Ensure that docker server certificate key file permissions are set to 400 (manual )" ;;
        "3.15") echo "Ensure that the docker socket file ownership is set to root:docker (Automated)" ;;
        "3.16") echo "Ensure that the docker socket file permissions are set to 660 or more restrictively (Automated)" ;;
        "3.17") echo "Ensure that daemon.json file ownership is set to root:root (manual)" ;;
        "3.18") echo "Ensure that daemon.json file permissions are set to 644 or more restrictively (manual)" ;;
        "3.19") echo "Ensure that /etc/default/docker file ownership is set to root:root (manual)" ;;
        "3.20") echo "Ensure that the /etc/default/docker file permission are set to 644 or more restrictively (manual)" ;;
        "3.21") echo "Ensure that /etc/sysconfig/docker file permissions are set to 644 or more restrictively (manual)" ;;
        "3.22") echo "Ensure that the /etc/sysconfig/docker file ownership is set to root:root (manual)" ;;
        "3.23") echo "Ensure that the containerd socket file ownership is set to root:root (Automated)" ;;
        "3.24") echo "Ensure that the containerd socker file permissions are set to 660 or more restrictively (Automated)" ;;
    esac
}

# Run control function and handle the output
run_control() {
    local control_number="$1"
    local function_file="$2"
    local report_file="$3"
    local control_status=""
    local control_heading="$(get_control_heading "$control_number")"

    total_recommendations=$((total_recommendations + 1))

    if [[ "$report_file" == "$audit_report_file" ]]; then
        if is_excluded "$control_number"; then
            control_status="[ SKIPPED ]"
            skipped_recommendations=$((skipped_recommendations + 1))
        else
            if [[ -f "$function_file" ]]; then
                echo "Running control $control_number..."
                if source "$function_file"; then
                    control_status="[ PASS ]"
                    passed_recommendations=$((passed_recommendations + 1))
                else
                    control_status="[ FAIL ]"
                    failed_recommendations=$((failed_recommendations + 1))
                fi
            else
                control_status="[ FAIL ]"
                failed_recommendations=$((failed_recommendations + 1))
            fi
        fi
    else
        if [[ -f "$function_file" ]]; then
            echo "Running control $control_number..."
            if source "$function_file"; then
                control_status="[ PASS ]"
                remediated_recommendations=$((remediated_recommendations + 1))
            else
                control_status="[ FAIL ]"
                manual_recommendations=$((manual_recommendations + 1))
            fi
        else
            control_status="[ FAIL ]"
            manual_recommendations=$((manual_recommendations + 1))
        fi
    fi

    echo "$control_status: $control_number - $control_heading" >> "$report_file"
}

# Summary generation for report
generate_summary() {
    local report_file="$1"

    echo "" >> "$report_file"
    echo "Summary" >> "$report_file"
    echo "--------" >> "$report_file"
    echo "Total Recommendations: $total_recommendations" >> "$report_file"
    echo "Skipped Recommendations: $skipped_recommendations" >> "$report_file"
    echo "Excluded Recommendations: $excluded_recommendations" >> "$report_file"
    echo "Passed Recommendations: $passed_recommendations" >> "$report_file"
    echo "Remediated Recommendations: $remediated_recommendations" >> "$report_file"
    echo "Manual Recommendations: $manual_recommendations" >> "$report_file"
    echo "Failed Recommendations: $failed_recommendations" >> "$report_file"
}

# List of all controls
controls=(
   "1.1.1" "1.1.2" "1.1.3" "1.1.4" "1.1.5" "1.1.6" "1.1.7" "1.1.8" "1.1.9" "1.1.10"
    "1.1.11" "1.1.12" "1.1.13" "1.1.14" "1.1.15" "1.1.16" "1.1.17" "1.1.18"
    "1.2.1" "1.2.2" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "2.10" "2.11"
    "2.12" "2.13" "2.14" "2.15" "2.16" "2.17" "2.18" "3.1" "3.2" "3.3" "3.4" "3.5"
    "3.6" "3.7" "3.8" "3.9" "3.10" "3.11" "3.12" "3.13" "3.14" "3.15" "3.16" "3.17" "3.18"
    "3.19" "3.20" "3.21" "3.22" "3.23" "3.24"
)

# Check if the script is run in hardening mode
if [[ "$1" == "harden" ]]; then
    # Initialize the hardening report
    echo "Hardening Report" > "$hardening_report_file"
    echo "Hardening Date: $audit_date" >> "$hardening_report_file"
    echo "Server Name: $server_name" >> "$hardening_report_file"
    echo "----------------------------------------" >> "$hardening_report_file"
    
    # Execute hardening functions
    for control in "${controls[@]}"; do
        function_file="functions/hardening/function_${control//./_}.sh"
        run_control "$control" "$function_file" "$hardening_report_file"
    done

    # Check if auditd needs to be restarted
    if [[ -f /tmp/auditd_restart_required ]]; then
        echo "Restarting auditd..."
        systemctl restart auditd
        rm /tmp/auditd_restart_required
    fi

    # Restart Docker if necessary
    if [[ -f /tmp/docker_restart_required ]]; then
        echo "Restarting Docker..."
        systemctl restart docker
        rm /tmp/docker_restart_required
    fi
    
    generate_summary "$hardening_report_file"
    echo "Hardening report generated at: $hardening_report_file"
else
    # Initialize the audit report
    echo "Audit Report" > "$audit_report_file"
    echo "Audit Date: $audit_date" >> "$audit_report_file"
    echo "Server Name: $server_name" >> "$audit_report_file"
    echo "----------------------------------------" >> "$audit_report_file"
    
    # Execute auditing functions
    for control in "${controls[@]}"; do
        function_file="functions/auditing/function_${control//./_}.sh"
        run_control "$control" "$function_file" "$audit_report_file"
    done
    
    generate_summary "$audit_report_file"
    echo "Audit report generated at: $audit_report_file"
fi
