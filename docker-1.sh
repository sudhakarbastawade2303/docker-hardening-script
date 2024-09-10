#!/bin/bash

echo "Starting Docker host hardening..."

### Automated Tasks

# Ensure audit rules directory exists
if [ ! -d "/etc/audit/rules.d/" ]; then
    mkdir -p /etc/audit/rules.d/
fi

# Function to configure auditing
configure_audit() {
  local file=$1
  local rule="-w ${file} -p wa -k docker"
  if ! grep -q "$rule" /etc/audit/rules.d/audit.rules 2>/dev/null; then
    echo "$rule" >> /etc/audit/rules.d/audit.rules
    echo "Configured auditing for $file"
  else
    echo "Auditing for $file is already configured"
  fi
}

# Configure auditing for Docker files and directories
echo "Configuring auditing for Docker files and directories..."
configure_audit /usr/bin/dockerd
configure_audit /etc/docker
configure_audit /etc/docker/daemon.json
configure_audit /etc/containerd/config.toml
configure_audit /etc/default/docker
configure_audit /etc/sysconfig/docker
configure_audit /usr/bin/containerd
configure_audit /usr/bin/containerd-shim
configure_audit /usr/bin/containerd-shim-runc-v2
configure_audit /usr/bin/runc

# Restart audit daemon if installed
echo "Reloading audit rules..."
if command -v auditctl &> /dev/null; then
  if command -v systemctl &> /dev/null; then
    systemctl restart auditd
  else
    service auditd restart
  fi
else
  echo "auditd is not installed. Skipping auditd restart."
fi

# Permissions and ownership settings
echo "Setting permissions and ownership for Docker-related files..."
for file in /lib/systemd/system/docker.service /lib/systemd/system/docker.socket /etc/docker /var/run/docker.sock /run/containerd/containerd.sock; do
  if [ -f "$file" ] || [ -d "$file" ]; then
    case $file in
      /lib/systemd/system/docker.service | /lib/systemd/system/docker.socket)
        chown root:root "$file"
        chmod 644 "$file"
        ;;
      /etc/docker)
        chown root:root "$file"
        chmod 755 "$file"
        ;;
      /var/run/docker.sock)
        chown root:docker "$file"
        chmod 660 "$file"
        ;;
      /run/containerd/containerd.sock)
        chown root:root "$file"
        chmod 660 "$file"
        ;;
    esac
  else
    echo "File or directory $file not found. Skipping."
  fi
done

echo "Automated tasks completed. Proceeding to manual tasks..."

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

