#!/bin/bash
# -----------------------------
# 01-setup-host.sh
# Hardens a fresh Ubuntu 24.04 server for SCIM Bridge deployment
# Installs security updates, configures firewall, installs Docker
# -----------------------------
set -e

echo "[+] Updating system and installing security tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y ufw fail2ban unattended-upgrades curl gnupg2 ca-certificates

echo "[+] Enabling daily unattended upgrades at 2:00am and auto-reboot at 2:30am..."
sudo bash -c 'cat > /etc/apt/apt.conf.d/20auto-upgrades' <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:30";
EOF

echo "[+] Configuring UFW to allow only HTTPS (443)..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 443/tcp comment 'HTTPS - SCIM Bridge'
sudo ufw --force enable

echo "[+] Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker

echo "[+] Initializing Docker Swarm..."
docker swarm init --advertise-addr 127.0.0.1

echo "[+] Creating Docker prune cronjob..."
echo "0 4 * * * docker image prune -af --filter \"until=240h\"" | sudo tee /etc/cron.d/docker-prune

echo "[✓] Host setup complete. Consider rebooting to apply all changes."
