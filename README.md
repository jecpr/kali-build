# Kali Linux Build Playbook

Ansible playbook to customise a fresh Kali Linux install with pentesting tools, terminal configuration, and browser setup.

## What it does

- **Terminal**: Configures zsh with a VPN-aware prompt, xfce4-terminal theming, and tmux
- **Tools**: Installs pentesting tools from Kali repos (NetExec, Impacket, Certipy, BloodyAD, evil-winrm, Chisel, SecLists, etc.) plus GitHub releases (PEASS-ng, Chainsaw, SharpCollection)
- **BloodHound CE**: Docker Compose deployment with containers pre-pulled
- **Docker**: Installs Docker CE from Docker's official repo with Compose plugin
- **Browser**: Firefox ESR policies (privacy, extensions, Burp CA) and Burp Suite configuration
- **System**: Passwordless sudo, VS Code, Syncthing, Obsidian
- **Volatility**: Both Volatility 2 and 3 for memory forensics

## Prerequisites

- Fresh Kali Linux install (XFCE desktop)
- Ansible installed: `sudo apt install ansible`
- Galaxy dependencies: `ansible-galaxy install -r requirements.yml`

## Usage

```bash
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml --ask-become-pass
```

To start BloodHound CE after the playbook runs:

```bash
cd /opt/bloodhound-ce && docker compose up -d
```

## Configuration

All variables are in `group_vars/all.yml`. Key options:

| Variable | Default | Description |
|----------|---------|-------------|
| `terminal_font` | `Monospace 14` | Terminal font |
| `terminal_bg` | `#141c2b` | Terminal background colour |
| `terminal_fg` | `#a4b1cd` | Terminal foreground colour |
| `install_volatility2` | `true` | Install Volatility 2 (requires Python 2) |
| `install_volatility3` | `true` | Install Volatility 3 |

## Notes

- Run `getburpcert.sh` after first Burp Suite launch to extract and install the CA certificate
- BloodHound CE UI is at `http://localhost:8080` after starting the containers
