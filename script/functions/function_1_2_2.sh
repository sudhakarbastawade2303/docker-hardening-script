#!/bin/bash
# Function to check "Ensure that the version of Docker is up to date"
echo "Checking 2.2: Ensure that the version of Docker is up to date"
# Check Docker version
docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
latest_version="<latest_version>" # Replace with the latest version number
if [ "$docker_version" == "$latest_version" ]; then
  echo "Pass: Docker is up to date ($docker_version)."
else
  echo "Fail: Docker is not up to date. Current version: $docker_version, Expected: $latest_version."
fi

