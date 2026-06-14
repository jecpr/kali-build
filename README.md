# Kali Linux Build Playbook

Ansible playbook to customise a fresh Kali Linux install with pentesting tools, terminal configuration, and browser setup.

## What it does

- **Terminal**: Configures zsh with a VPN-aware prompt, xfce4-terminal theming, and tmux
- **Tools**: Installs pentesting tools via apt, pipx, gem, and GitHub releases (Chisel, PEASS-ng, BloodHound, Kerbrute, Impacket, NetExec, Certipy, evil-winrm, etc.)
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

## Configuration

All variables are in `group_vars/all.yml`. Key options:

| Variable | Default | Description |
|----------|---------|-------------|
| `terminal_font` | `Monospace 14` | Terminal font |
| `terminal_bg` | `#141c2b` | Terminal background colour |
| `terminal_fg` | `#a4b1cd` | Terminal foreground colour |
| `obsidian_version` | `1.8.10` | Obsidian version to install |
| `install_volatility2` | `true` | Install Volatility 2 (requires Python 2) |
| `install_volatility3` | `true` | Install Volatility 3 |

## Notes

- Run `getburpcert.sh` after first Burp Suite launch to extract and install the CA certificate
