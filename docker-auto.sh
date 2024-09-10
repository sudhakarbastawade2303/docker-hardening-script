#!/bin/bash

echo "Starting Docker host hardening..."

### Automated Tasks

##Ensure Auditing is configured for docker daemon 

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