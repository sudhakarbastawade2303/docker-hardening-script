#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - /etc/docker/daemon.json"
echo "Checking 1.1.10: Ensure auditing is configured for Docker files and directories - /etc/docker/daemon.json"
# Check if /etc/docker/daemon.json is being audited
auditctl -l | grep -E "/etc/docker/daemon.json" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for /etc/docker/daemon.json."
else
  echo "Fail: Auditing is not configured for /etc/docker/daemon.json."
fi

