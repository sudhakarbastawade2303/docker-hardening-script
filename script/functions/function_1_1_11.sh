#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - /usr/bin/containerd"
echo "Checking 1.1.11: Ensure auditing is configured for Docker files and directories - /usr/bin/containerd"
# Check if /usr/bin/containerd is being audited
auditctl -l | grep -E "/usr/bin/containerd" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for /usr/bin/containerd."
else
  echo "Fail: Auditing is not configured for /usr/bin/containerd."
fi

