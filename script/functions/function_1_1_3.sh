#!/bin/bash
# Function to check "Ensure auditing is configured for the Docker daemon"
echo "Checking 1.1.3: Ensure auditing is configured for the Docker daemon"
# Verify that auditing rules for Docker are in place
auditctl -l | grep -E "/usr/bin/dockerd" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for the Docker daemon."
else
  echo "Fail: Auditing is not configured for the Docker daemon."
fi

