#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - /etc/docker"
echo "Checking 1.1.6: Ensure auditing is configured for Docker files and directories - /etc/docker"
# Check if /etc/docker is being audited
auditctl -l | grep -E "/etc/docker" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for /etc/docker."
else
  echo "Fail: Auditing is not configured for /etc/docker."
fi

