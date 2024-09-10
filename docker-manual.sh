#!/bin/bash

### Manual Tasks Validation

# Function to check if a configuration is present in a file
check_config() {
  local file=$1
  local config=$2
  if [ -f "$file" ]; then
    grep -q "$config" "$file" && echo "PASS: $config found in $file" || echo "FAIL: $config not found in $file"
  else
    echo "FAIL: $file does not exist"
  fi
}

echo "Validating manual hardening steps..."

# 1. Check if a separate partition is created for Docker
echo "Checking if a separate partition is created for Docker..."
mount | grep -q "/var/lib/docker" && echo "PASS: Separate partition for Docker exists" || echo "FAIL: Separate partition for Docker does not exist"

# 2. Check if Docker daemon access is restricted to trusted users
echo "Checking Docker daemon access..."
getent group docker >/dev/null && echo "PASS: Docker group exists" || echo "FAIL: Docker group does not exist"
grep -q "trusted-username" /etc/group && echo "PASS: Trusted user has access to Docker daemon" || echo "FAIL: Trusted user does not have access to Docker daemon"

# 3. Check if Docker daemon is running as a non-root user
echo "Checking if Docker daemon is running as a non-root user..."
ps -eo user,comm | grep -E "^docker.*dockerd" && echo "PASS: Docker daemon is running as non-root user" || echo "FAIL: Docker daemon is running as root"

# 4. Check if network traffic between containers is restricted
echo "Checking Docker inter-container communication..."
check_config /etc/docker/daemon.json '"icc": false'

# 5. Check if logging level is set to 'info'
echo "Checking Docker logging level..."
check_config /etc/docker/daemon.json '"log-level": "info"'

# 6. Check if Docker is allowed to modify iptables
echo "Checking Docker iptables configuration..."
check_config /etc/docker/daemon.json '"iptables": true'

# 7. Check for insecure registries
echo "Checking for insecure registries..."
check_config /etc/docker/daemon.json '"insecure-registries": []'

# 8. Check if AUFS storage driver is not used
echo "Checking if AUFS storage driver is not used..."
docker info | grep -q "Storage Driver: aufs" && echo "FAIL: AUFS storage driver is in use" || echo "PASS: AUFS storage driver is not used"

# 9. Check if TLS authentication is configured
echo "Checking for TLS authentication..."
if [ -d "/etc/docker/certs.d/" ]; then
  ls /etc/docker/certs.d/ >/dev/null && echo "PASS: TLS authentication is configured" || echo "FAIL: TLS authentication is not configured"
else
  echo "FAIL: TLS authentication directory /etc/docker/certs.d/ does not exist"
fi

# 10. Check default ulimit configuration
echo "Checking default ulimit configuration..."
check_config /etc/docker/daemon.json '"default-ulimit":'

# 11. Check if user namespace support is enabled
echo "Checking user namespace support..."
check_config /etc/docker/daemon.json '"userns-remap":'

# 12. Check cgroup usage
echo "Checking Docker cgroup usage..."
docker info | grep -q "Cgroup" && echo "PASS: Docker cgroup usage confirmed" || echo "FAIL: Docker cgroup usage not confirmed"

# 13. Check if base device size is configured only when needed
echo "Checking base device size..."
check_config /etc/docker/daemon.json '"storage-opts": ["dm.basesize='

# 14. Check for authorization for Docker client commands
echo "Checking Docker client command authorization..."
docker plugin ls | grep -q "authz" && echo "PASS: Docker client authorization is enabled" || echo "FAIL: Docker client authorization is not enabled"

# 15. Check centralized and remote logging configuration
echo "Checking centralized and remote logging..."
check_config /etc/docker/daemon.json '"log-driver":'

# 16. Check if containers are restricted from acquiring new privileges
echo "Checking container privilege restrictions..."
check_config /etc/docker/daemon.json '"no-new-privileges": true'

# 17. Check if live restore is enabled
echo "Checking live restore configuration..."
check_config /etc/docker/daemon.json '"live-restore": true'

# 18. Check if userland proxy is disabled
echo "Checking userland proxy configuration..."
check_config /etc/docker/daemon.json '"userland-proxy": false'

# 19. Check if custom seccomp profile is applied
echo "Checking for custom seccomp profile..."
check_config /etc/docker/daemon.json '"seccomp-profile":'

# 20. Check if experimental features are disabled in production
echo "Checking experimental features..."
check_config /etc/docker/daemon.json '"experimental": false'

echo "Manual hardening steps validation completed."

echo "Docker host hardening script completed."
