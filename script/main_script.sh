#!/bin/bash

# Get the audit date and server name
audit_date=$(date '+%Y-%m-%d %H:%M:%S')
server_name=$(hostname)

# Initialize the report file
report_file="audit_report.txt"
echo "Audit Date: $audit_date" > "$report_file"
echo "Server Name: $server_name" >> "$report_file"
echo "Validation Report:" >> "$report_file"
echo "----------------------------------------" >> "$report_file"

# Load the exclusion list into an array
exclusions=()
while IFS= read -r line || [[ -n "$line" ]]; do
    exclusions+=("$line")
done < exclusion_list.txt

# Function to check if a control is excluded
is_excluded() {
    local control="$1"
    for excluded in "${exclusions[@]}"; do
        if [[ "$excluded" == "$control" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to get control heading
get_control_heading() {
    local control_number="$1"
    case "$control_number" in
        "1.1.1") echo "Ensure a separate partition for containers has been created" ;;
        "1.1.2") echo "Ensure only trusted users are allowed to control Docker daemon" ;;
        # Add more mappings for control numbers to control headings as needed
        *) echo "Unknown Control" ;;
    esac
}

# Run each control function
run_control() {
    local control_number="$1"
    local function_file="functions/function_${control_number//./_}.sh"
    local control_status=""

    if is_excluded "$control_number"; then
        control_status="Skipped (Excluded)"
    elif [[ -f "$function_file" ]]; then
        echo "Running control $control_number..."
        # Execute the function file and capture the exit status
        if source "$function_file"; then
            control_status="Pass"
        else
            control_status="Fail"
        fi
    else
        control_status="Fail (Function file not found)"
    fi

    # Print the status first, then the control number and heading
    echo "$control_status: $control_number - $(get_control_heading "$control_number")" >> "$report_file"
}


# List of all controls
controls=(
    "1.1.1" "1.1.2" "1.1.3" "1.1.4" "1.1.5" "1.1.6" "1.1.7" "1.1.8" "1.1.9" "1.1.10"
    "1.1.11" "1.1.12" "1.1.13" "1.1.14" "1.1.15" "1.1.16" "1.1.17" "1.1.18"
    "1.2.1" "1.2.2" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "2.10" "2.11"
    "2.12" "2.12" "2.13" "2.14" "2.15" "2.16" "2.17" "2.18" "3.1" "3.2" "3.3" "3.4" "3.5"
    "3.6" "3.7" "3.8" "3.9" "3.10" "3.11" "3.12" "3.13" "3.14" "3.15" "3.16" "3.17" "3.18"
    "3.19" "3.20" "3.21" "3.22" "3.23" "3.24"
    # Continue adding all the control numbers
)

# Execute all controls
for control in "${controls[@]}"; do
    run_control "$control"
done

echo "Audit report generated at: $report_file"
