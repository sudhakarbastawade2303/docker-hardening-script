#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - containerd.sock"
echo "Checking 1.1.8: Ensure auditing is configured for Docker files and directories - containerd.sock"
# Check if containerd.sock is being audited
auditctl -l | grep -E "containerd.sock" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for containerd.sock."
else
  echo "Fail: Auditing is not configured for containerd.sock."
fi

