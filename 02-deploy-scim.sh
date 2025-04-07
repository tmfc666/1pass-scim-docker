#!/bin/bash
# -----------------------------
# 02-deploy-scim.sh
# Deploys or redeploys the SCIM Bridge stack in Docker Swarm
# Optionally includes Google Workspace config
# -----------------------------
set -e

echo "[+] Securing secrets directory permissions..."
chmod 600 ./secrets/scimsession ./google-workspace/workspace-settings.json
chmod 600 ./secrets/bearer_token.txt || true

echo "[+] Deploying SCIM Bridge stack..."
if [ "$1" == "--google" ]; then
  docker stack config \
    --compose-file ./compose.template.yaml \
    --compose-file ./google-workspace/compose.gw.yaml \
    | docker stack deploy --compose-file - op-scim-bridge
else
  docker stack config \
    --compose-file ./compose.template.yaml \
    | docker stack deploy --compose-file - op-scim-bridge
fi

# Set restart policy to on-failure
docker service update --restart-condition on-failure op-scim-bridge_scim || true

echo "[✓] SCIM Bridge deployed and configured to restart on failure."
