#!/bin/bash
# Function to check "Ensure auditing is configured for Docker files and directories - docker.service"
echo "Checking 1.1.7: Ensure auditing is configured for Docker files and directories - docker.service"
# Check if docker.service is being audited
auditctl -l | grep -E "docker.service" &> /dev/null
if [ $? -eq 0 ]; then
  echo "Pass: Auditing is configured for docker.service."
else
  echo "Fail: Auditing is not configured for docker.service."
fi

