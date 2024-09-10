#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - /var/lib/docker"
echo "Checking 1.1.5: Ensure auditing is configured for Docker files and directories - /var/lib/docker"
# Check if /var/lib/docker is being audited
auditctl -l | grep -E "/var/lib/docker" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for /var/lib/docker."
else
  echo "Fail: Auditing is not configured for /var/lib/docker."
fi

