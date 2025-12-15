#!/usr/bin/env bash
set -euo pipefail

# --- Guardrails ---
if [[ $EUID -eq 0 ]]; then
  echo "Please run as a normal user (it will use sudo)."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo not found. Install sudo or run as root."
  exit 1
fi

if [[ -f /etc/os-release ]]; then
  . /etc/os-release
else
  echo "Cannot detect OS."
  exit 1
fi

if [[ "${ID:-}" != "ubuntu" && "${ID:-}" != "debian" ]]; then
  echo "Unsupported OS: ${ID:-unknown}. This script is for Ubuntu/Debian."
  exit 1
fi

echo "WARNING: This will REMOVE Pterodactyl Panel + Wings + Nginx + PHP + DBs + Redis + Docker"
echo "and DELETE panel/wings files and potentially game server data."
echo
read -r -p "Type DELETE-PTERODACTYL to continue: " confirm
if [[ "$confirm" != "DELETE-PTERODACTYL" ]]; then
  echo "Cancelled."
  exit 0
fi

echo "Stopping services (if present)..."
sudo systemctl stop wings nginx mysql mariadb redis-server docker 2>/dev/null || true
sudo systemctl disable wings nginx mysql mariadb redis-server docker 2>/dev/null || true

echo "Purging packages..."
sudo apt-get update -y
sudo apt-get purge -y \
  nginx nginx-common nginx-core \
  'php*' \
  mariadb-server mariadb-client \
  mysql-server mysql-client \
  redis-server \
  docker docker-engine docker.io containerd runc \
  pterodactyl-wings pterodactyl-panel 2>/dev/null || true

sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "Removing files..."
sudo rm -rf \
  /var/www/pterodactyl \
  /etc/pterodactyl \
  /var/lib/pterodactyl \
  /var/log/pterodactyl \
  /etc/nginx \
  /var/log/nginx \
  /etc/php \
  /var/lib/mysql \
  /var/lib/mariadb \
  /etc/mysql \
  /var/lib/redis \
  /etc/redis \
  /var/lib/docker \
  /etc/docker \
  /srv/daemon-data \
  /srv/pterodactyl \
  /root/.composer \
  /home/*/.composer || true

echo "Removing pterodactyl user/group (if exists)..."
sudo deluser --remove-home pterodactyl 2>/dev/null || true
sudo delgroup pterodactyl 2>/dev/null || true

echo "Firewall flush (iptables)..."
sudo iptables -F || true
sudo iptables -X || true
sudo iptables -t nat -F || true
sudo iptables -t nat -X || true

echo
echo "Done! (reboot is recommended)"
read -r -p "Reboot now? (y/N): " rb
if [[ "${rb,,}" == "y" ]]; then
  sudo reboot
else
  echo "Reboot later with: sudo reboot"
fi
