# 🛡️ SCIM Bridge Deployment (Self-Hosted, Secure, Dockerized)

A secure, easy-to-deploy, and self-maintaining 1Password SCIM Bridge setup for Ubuntu 24.04 with Docker Swarm.  
Includes hardening, auto-updates, restart logic, and a user-friendly menu.

---

## 🧠 Who is this for?

Ideal for IT teams running lean infrastructure who want SCIM provisioning without cloud hosting costs.  
This repo is hardened, clean, and accessible even for newer sysadmins.

---

## 🚀 Quick Start

### 1. SSH into your host and run the menu

```bash
./menu.sh
```

This interactive script lets you:
- Harden the host and install Docker
- Deploy SCIM Bridge (with or without Google Workspace)
- View service logs
- Trigger a manual update

---

## 🛠 Requirements

- Ubuntu 24.04 host (with public IP or reachable via DNS)
- 1Password SCIM session file
- Google service account key (if using Workspace integration)
- Docker will be installed and managed automatically

---

## 🔐 Secure Your Secrets

Copy these files into the appropriate locations on your host:

| Secret               | Destination                             | Required?  |
|----------------------|------------------------------------------|------------|
| `scimsession`        | `./secrets/scimsession`                  | ✅         |
| `bearer_token.txt`   | `./secrets/bearer_token.txt`             | Optional   |
| GCP service account  | `./google-workspace/workspace-settings.json` | ✅ (Google only) |

Secure them:

```bash
chmod 600 ./secrets/scimsession ./google-workspace/workspace-settings.json
chmod 600 ./secrets/bearer_token.txt  # if used
```

---

## 🧰 Features

### ✅ Hardened Host Setup

Run once to:
- Enable daily `unattended-upgrades` and reboots
- Lock down firewall to **443/tcp only**
- Install Docker and enable Docker Swarm
- Create a daily cron job to prune unused Docker images (`docker image prune`)

```bash
./01-setup-host.sh
```

### ✅ Deploy the SCIM Bridge Stack

```bash
./02-deploy-scim.sh             # Without Google
./02-deploy-scim.sh --google    # With Google Workspace integration
```

This sets up:
- Docker stack
- Let’s Encrypt TLS
- UID isolation (`999:999`)
- Auto-restart on failure (`--restart-condition on-failure`)

---

## 🧾 Scheduled Maintenance

- **Docker image update (monthly):**  
  Installed automatically via cron in `cron/docker-update-scim.sh`

```bash
0 3 1 * * /opt/scim-bridge-deploy/cron/docker-update-scim.sh >> /var/log/scim-update.log 2>&1
```

- **Docker image cleanup (daily):**  
  Configured via `/etc/cron.d/docker-prune`:
```bash
0 4 * * * docker image prune -af --filter "until=240h"
```

---

## 📡 Monitoring with Zabbix

You can monitor:
- `systemctl status scim-bridge`
- `journalctl -u scim-bridge`
- Port 443 availability (TLS check)

---

## 📁 Repo Structure

```
scim-bridge-deploy/
├── 01-setup-host.sh
├── 02-deploy-scim.sh
├── menu.sh
├── scim.env
├── .gitignore
├── README.md
├── compose.template.yaml
├── scim-bridge.service
├── cron/
│   └── docker-update-scim.sh
├── secrets/
│   ├── scimsession
│   └── bearer_token.txt
└── google-workspace/
    └── workspace-settings.json
```

---

## 📬 Maintained by

- tmfc666
- tmfc666@gmail.com

This setup is battle-tested and used in production. PRs welcome!
