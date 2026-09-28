# NixOS + Hyprland dotfiles

A modular, multi-host NixOS configuration using flakes and Home Manager,
running Hyprland across a laptop and a desktop.

## Hosts

| Host      | Hardware                                                     | Profile Details |
|-----------|--------------------------------------------------------------|-----------------|
| `laptop`  | Lenovo IdeaPad 5 Pro 16ACH6 (AMD Ryzen 5000 + NVIDIA PRIME) | 2.5K 120Hz display, battery & power-profiles daemon, scaled fonts |
| `desktop` | ASUS PRIME B660, Intel Core i5, RTX 3080                     | Dual 1440p @ 165Hz monitors, compact UI font scaling |

## Stack

- **Window Manager:** Hyprland
- **Status Bar, Notifications & OSD:** Quickshell
- **Application Launcher & Hub:** Rofi Wayland
- **Screen Locker & Idle:** Hyprlock + Hypridle
- **Terminal:** Kitty (GPU-accelerated, FiraCode Nerd Font)
- **Shell & Prompt:** Zsh + Starship
- **Multiplexer:** Tmux
- **Screen Recording & Capture:** `wf-recorder` (NVIDIA DMA-BUF buffer support), Grim, Slurp, Swappy
- **AI Stack:** Ollama (CUDA acceleration on-demand), `llm-agents.nix` (`opencode`, `antigravity-cli`)
- **Wallpaper Daemon:** `awww`
- **Dynamic Theming:** Instant switching across GTK, Qt, Kitty, Quickshell, Starship, Btop, Rofi, and Hyprland (Gruvbox, Kanagawa, Miasma)

## Structure

```
├── flake.nix                             # Multi-host flake inputs & configuration outputs
├── flake.lock
├── hosts/
│   ├── laptop/
│   │   ├── configuration.nix             # Laptop system configuration
│   │   ├── hardware-configuration.nix    # Machine-specific LUKS & disk mounts
│   │   └── gpu.nix                       # Hybrid AMD + NVIDIA PRIME offload
│   └── desktop/
│       ├── configuration.nix             # Desktop system configuration
│       ├── hardware-configuration.nix    # Machine-specific LUKS & disk mounts
│       └── gpu.nix                       # Standalone NVIDIA GPU setup
├── modules/                              # Shared system modules
│   ├── nix.nix                           # Flakes, auto-optimise-store, nix.gc
│   ├── boot.nix                          # Systemd-boot, configurationLimit, zramSwap
│   ├── networking.nix                    # NetworkManager, timezones & locales
│   ├── users.nix                         # User accounts & groups
│   ├── desktop.nix                       # Hyprland, Greetd, Pipewire, Polkit, Fonts
│   ├── programs.nix                      # Docker (on-demand), Steam, Thunar
│   ├── packages.nix                      # System packages & dev tools
│   └── services.nix                      # Ollama (CUDA), Bluetooth, Syncthing
└── home/
    ├── home.nix                          # Base Home Manager entrypoint
    ├── settings.nix                      # Declarative per-host font and UI sizing options
    ├── hosts/
    │   ├── laptop.nix                    # Laptop hostSettings (fontSize = 13, barHeight = 34)
    │   └── desktop.nix                   # Desktop hostSettings (fontSize = 11, barHeight = 30)
    ├── hypr.nix + hypr/                  # hyprland.lua, hypridle, hyprlock, scripts
    ├── quickshell.nix + quickshell/      # QML bar, volume/brightness OSD, notifications
    ├── rofi.nix + rofi/                  # Hub, launchers, menus, and reminder scripts
    ├── theme.nix + themes/               # Gruvbox, Kanagawa, Miasma themes & hooks
    ├── kitty.nix                         # Terminal config & keybindings
    ├── zsh.nix                           # Zsh aliases, yazi wrapper, zoxide integration
    ├── tmux.nix                          # Tmux config
    ├── btop.nix                          # System monitor config
    └── starship.nix                      # Shell prompt configuration
```

## Declarative Per-Host UI Scaling

Font sizes and bar dimensions are managed in a single declarative location:
- [`home/settings.nix`](file:///home/nik/.config/nixos/home/settings.nix) defines the options: `fontFamily`, `uiFontFamily`, `fontSize`, `fontSizeSmall`, `kittyFontSize`, and `barHeight`.
- Host overrides in [`home/hosts/laptop.nix`](file:///home/nik/.config/nixos/home/hosts/laptop.nix) and [`home/hosts/desktop.nix`](file:///home/nik/.config/nixos/home/hosts/desktop.nix) automatically propagate to Kitty, Rofi, Quickshell, and GTK interfaces without manual duplication.

## Keybindings Cheat Sheet

| Keybinding | Action |
|---|---|
| `Super + Return` | Open Terminal (Kitty) |
| `Super + Space` | Application Launcher (Rofi) |
| `Super + Alt + Space` | System Control Hub (Rofi) |
| `Super + E` | Graphical File Manager (Thunar) |
| `Super + Y` | Terminal File Manager (Yazi) |
| `Super + V` | Clipboard History Manager |
| `Super + Shift + T` | Theme Switcher (Gruvbox, Kanagawa, Miasma) |
| `Super + Shift + W` | Wallpaper Gallery Selector |
| `Super + Alt + R` | Screen Recording (Fullscreen, `wf-recorder`) |
| `Super + Shift + R` | Screen Recording (Select Region, `wf-recorder`) |
| `Print` | Screenshot (Region to file & clipboard) |
| `Super + Shift + P` | Screenshot with Annotation (Swappy) |
| `Super + Shift + C` | Color Picker (Hyprpicker) |
| `Super + Shift + O` | OCR Text Grabber (Tesseract) |
| `Super + Ctrl + R` | Quick Reminders & Pomodoro Timer |
| `Super + /` | Interactive Keybindings Cheat Sheet |
| `Super + Escape` | Power Menu (Lock, Suspend, Reboot, Shutdown) |
| `Ctrl + L` | Lock Screen immediately (Hyprlock) |

## Day-to-Day Maintenance

Aliases defined in [`home/zsh.nix`](file:///home/nik/.config/nixos/home/zsh.nix) automatically detect the active host via `$(hostname)`:

| Command | Description |
|---|---|
| `nrs` | Build and switch configuration (`sudo nixos-rebuild switch --flake`) |
| `nrb` | Build configuration without switching (dry check) |
| `nfu` | Update flake inputs (`nix flake update`) |

To roll back to the previous generation:
```bash
sudo nixos-rebuild switch --rollback
```

## Installing on a New Machine

1. Clone the repository:
   ```bash
   git clone <repo-url> ~/.config/nixos
   ```
2. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > ~/.config/nixos/hosts/<hostname>/hardware-configuration.nix
   ```
3. Add the file to git index so the flake can evaluate it:
   ```bash
   git add -f ~/.config/nixos/hosts/<hostname>/hardware-configuration.nix
   ```
4. Configure LUKS/disk UUIDs in the host configuration and register the host in `flake.nix`.
5. Build and activate:
   ```bash
   sudo nixos-rebuild switch --flake ~/.config/nixos#<hostname>
   ```
