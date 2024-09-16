#!/bin/bash

# Desired values
desired_nofile=1024
desired_nproc=2048

# Check current ulimit values
current_nofile=$(ulimit -n)
current_nproc=$(ulimit -u)

# Initialize status variable
status=0

# Function to check and print note if ulimit is not configured appropriately
check_ulimit() {
    local limit_name=$1
    local current_value=$2
    local desired_value=$3

    if (( current_value < desired_value )); then
        echo "FAIL: $limit_name is set to $current_value, which is less than the desired $desired_value."
        status=1
    else
        echo "PASS: $limit_name is configured correctly at $current_value."
    fi
}

# Check and print messages for nofile and nproc
check_ulimit "Maximum number of open files (nofile)" "$current_nofile" "$desired_nofile"
check_ulimit "Maximum number of processes (nproc)" "$current_nproc" "$desired_nproc"

# Exit with the status code
return $status
