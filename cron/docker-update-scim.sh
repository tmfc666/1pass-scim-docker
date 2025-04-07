#!/bin/bash
# -----------------------------
# docker-update-scim.sh
# Pulls latest SCIM image and redeploys stack with new version
# -----------------------------
echo "[+] Pulling latest SCIM image..."
docker pull 1password/scim:latest

echo "[+] Updating SCIM service to latest image..."
docker service update --image 1password/scim:latest op-scim-bridge_scim

echo "[✓] Update complete."
