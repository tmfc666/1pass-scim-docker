#!/bin/bash
# -----------------------------
# menu.sh
# Interactive wrapper to guide team members through SCIM setup tasks
# -----------------------------
set -e

function pause() {
  read -p "Press [Enter] to continue..."
}

function show_menu() {
  clear
  echo "===== SCIM Bridge Deployment Menu ====="
  echo "1) Harden host and install Docker"
  echo "2) Deploy SCIM Bridge"
  echo "3) Deploy SCIM Bridge (with Google Workspace)"
  echo "4) Show SCIM service logs"
  echo "5) Manually trigger SCIM update"
  echo "0) Exit"
}

while true; do
  show_menu
  read -p "Choose an option: " choice
  case $choice in
    1) ./01-setup-host.sh; pause ;;
    2) ./02-deploy-scim.sh; pause ;;
    3) ./02-deploy-scim.sh --google; pause ;;
    4) docker service logs op-scim-bridge_scim --raw; pause ;;
    5) ./cron/docker-update-scim.sh; pause ;;
    0) echo "Goodbye."; exit 0 ;;
    *) echo "Invalid option."; pause ;;
  esac
done
