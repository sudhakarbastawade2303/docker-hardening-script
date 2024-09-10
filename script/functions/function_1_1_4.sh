#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - /run/containerd"
echo "Checking 1.1.4: Ensure auditing is configured for Docker files and directories - /run/containerd"
# Check if /run/containerd is being audited
auditctl -l | grep -E "/run/containerd" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for /run/containerd."
else
  echo "Fail: Auditing is not configured for /run/containerd."
fi

