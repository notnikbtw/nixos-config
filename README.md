# NixOS + Hyprland dotfiles

A modular, multi-host NixOS configuration using flakes and home-manager,
running Hyprland (native Lua config) across a laptop and a desktop.

## Hosts

| Host      | Hardware                                          |
|-----------|----------------------------------------------------|
| `laptop`  | Lenovo IdeaPad 5 Pro 16ACH6 (AMD + NVIDIA PRIME)   |
| `desktop` | ASUS PRIME B660-PLUS D4, i5-12600KF, RTX 3080, dual monitor |

## Stack

- **WM:** Hyprland (Lua config, `hl.bind` API)
- **Bar & OSD:** Quickshell (status bar, notifications, and built-in volume/brightness OSD)
- **Launcher:** Rofi (drun, window switcher, powermenu, theme switcher, wallpaper switcher, control hub)
- **Lock/idle:** Hyprlock + Hypridle
- **Terminal:** Kitty
- **Shell:** Zsh + Starship
- **Multiplexer:** Tmux (auto-attached on new terminal)
- **AI Stack:** Ollama (CUDA acceleration), `llm-agents.nix` (`opencode`, `antigravity-cli`), AI CLIs (`aichat`, `tgpt`, `gemini-cli`)
- **Wallpaper:** awww (animated wallpaper daemon with per-theme galleries)
- **Theme:** Dynamic system-wide theming (Gruvbox, Kanagawa, TokyoNight, Miasma) across GTK, Qt, Kitty, Quickshell, Starship, Btop, Rofi, and Hyprland

## Structure

```
├── flake.nix                             # Multi-host flake with inputs (nixpkgs, home-manager, nixos-hardware, llm-agents)
├── flake.lock
├── hosts/
│   ├── laptop/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix   # Machine-specific LUKS & disk setup
│   │   └── gpu.nix                      # Hybrid AMD + NVIDIA PRIME offload & power management
│   └── desktop/
│       ├── configuration.nix
│       ├── hardware-configuration.nix   # Machine-specific LUKS & disk setup
│       └── gpu.nix                      # Standalone NVIDIA GPU setup
├── modules/                              # Shared system modules across ALL hosts
│   ├── nix.nix
│   ├── boot.nix                          # Generic systemd-boot loader
│   ├── networking.nix                    # NetworkManager, timezones & XKB locales
│   ├── users.nix                         # User accounts & groups
│   ├── desktop.nix                       # Hyprland, Greetd, Pipewire, Polkit & XDG Portals
│   ├── programs.nix                      # Docker, Steam, Thunar
│   ├── packages.nix                      # System packages & llm-agents tools
│   └── services.nix                      # Local AI services (Ollama CUDA)
└── home/
    ├── home.nix                          # Base Home Manager entrypoint
    ├── hosts/
    │   ├── laptop.nix                    # Laptop home-manager config & laptop Waybar
    │   └── desktop.nix                   # Desktop home-manager config & desktop Waybar
    ├── hypr.nix + hypr/                  # hyprland.lua, hypridle, hyprlock, wallpaper
    ├── hyprpaper.nix
    ├── waybar.nix + waybar/              # Split waybar configs (config-laptop.jsonc, config-desktop.jsonc)
    ├── rofi.nix + rofi/
    ├── dunst.nix + dunst/
    ├── kitty.nix
    ├── zsh.nix                           # Zsh, aliases, secrets loader
    ├── tmux.nix
    ├── starship.nix
    └── theme.nix                         # GTK/Qt/cursor, Gruvbox, dconf
```

## Prerequisites

Nix with flakes enabled:

```
experimental-features = nix-command flakes
```

## Installing on a new machine

If reusing this repo on genuinely different hardware, regenerate the hardware config rather than reusing an existing host's file:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
```

1. Clone the repo:
   ```bash
   git clone <this-repo-url> ~/.config/nixos
   ```
2. Generate hardware config for this machine:
   ```bash
   sudo nixos-generate-config --show-hardware-config > ~/.config/nixos/hosts/<hostname>/hardware-configuration.nix
   ```
   (create the `hosts/<hostname>/` folder first if it's a brand-new host,
   with a `configuration.nix` and `gpu.nix` - copy an existing host's as a
   starting point and adjust for the hardware)
3. Add the file to git's index so the flake can see it (it stays gitignored
   from being committed publicly, but Nix flakes only evaluate tracked
   files):
   ```bash
   git add -f hosts/<hostname>/hardware-configuration.nix
   ```
4. Update the LUKS UUID in `hosts/<hostname>/configuration.nix` (or
   `modules/boot.nix` if shared) to match your own disk - find it with
   `blkid`.
5. Register the host in `flake.nix` under `nixosConfigurations` if it's new.
6. Point `/etc/nixos` at the repo:
   ```bash
   sudo mv /etc/nixos /etc/nixos.bak
   sudo ln -s ~/.config/nixos /etc/nixos
   ```
7. Build:
   ```bash
   sudo nixos-rebuild switch --flake ~/.config/nixos#<hostname>
   ```

## Day-to-day usage

Aliases (defined in `home/zsh.nix`, auto-detect the current host via
`$(hostname)` - same commands work on both machines):

| Alias | Does |
|---|---|
| `nrb` | Build the config for this host without applying (dry check) |
| `nrs` | Build and switch for this host |
| `nfu` | `nix flake update` |

Full commands, if not using the aliases:

```bash
sudo nixos-rebuild build  --flake ~/.config/nixos#$(hostname)
sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)
```

Update dependencies (nixpkgs, home-manager, nixos-hardware) - affects both
hosts, since they share the same flake inputs:

```bash
cd ~/.config/nixos
nix flake update
nrs
```

Roll back if something breaks:

```bash
sudo nixos-rebuild switch --rollback
```
