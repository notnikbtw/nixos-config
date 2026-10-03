# NixOS dotfiles

My personal modular NixOS configuration with multiple hosts, using flakes and Home Manager, in which Hyprland runs simultaneously on a laptop and a desktop computer.

## Hosts

| Host      | Hardware                                                     | Profile Details |
|-----------|--------------------------------------------------------------|-----------------|
| `laptop`  | Lenovo IdeaPad 5 Pro (Ryzen 5000 / RTX 3050M)                | 2.5K 120Hz, battery profiles, scaled UI |
| `desktop` | Intel i5 / RTX 3080                                          | 2x 1440p @ 165Hz, compact UI |

## Stack

- **Window Manager:** Hyprland
- **Status Bar, Notifications & OSD:** Quickshell
- **Application Launcher & Hub:** Rofi Wayland
- **Screen Locker & Idle:** Hyprlock + Hypridle
- **Terminal:** Kitty (GPU-accelerated, FiraCode Nerd Font)
- **Shell & Prompt:** Zsh + Starship
- **Multiplexer:** Tmux (manual session management via `ta` / `tls`)
- **Screen Recording & Capture:** `wf-recorder` (NVIDIA DMA-BUF buffer support), Grim, Slurp, Swappy
- **AI Stack:** Docker Ollama (NVIDIA Container Toolkit GPU passthrough), `llm-agents.nix` (`opencode`, `antigravity-cli`)
- **Wallpaper Daemon:** `awww`
- **Dynamic Theming:** Instant switching across GTK, Qt, Kitty, Quickshell, Starship, Btop, Rofi, and Hyprland (Gruvbox, Kanagawa, Miasma)

## Declarative Per-Host UI Scaling

All font settings and per-device display scalings are defined in a single file:
- `home/settings.nix` defines the font families (`fontFamily`, `uiFontFamily`) and contains the profile table (`profiles.desktop` and `profiles.laptop`).
- Home Manager automatically resolves the active profile based on the host name (`hostname`), propagating the sizes to Kitty, Rofi, Quickshell, and GTK themes without any duplicate host files.

## Keybindings

### Window Management & Navigation
| Keybinding | Action |
|---|---|
| `Super + Return` | Open Terminal (Kitty) |
| `Super + Q` | Close active window |
| `Super + Shift + Q` | Force kill active window |
| `Super + M` / `Super + Shift + F` | Toggle fullscreen |
| `Super + \` | Toggle horizontal/vertical split |
| `Super + Shift + R` | Reload Hyprland configuration |
| `Super + H / J / K / L` | Focus window left / down / up / right (Vim keys) |
| `Super + Shift + H / J / K / L` | Move window left / down / up / right |
| `Super + Ctrl + H / J / K / L` / `Arrows` | Resize window ratio |
| `Super + R` | Enter Interactive Resize Mode (submap: `HJKL` / `Arrows` / Cyrillic `рдело` / `Esc` to exit) |
| `Super + 1..0` | Switch to workspace 1..10 |
| `Super + Shift + 1..0` | Move window to workspace 1..10 |
| `Super + \`` | Toggle scratchpad (`special:scratchpad`) |
| `Super + Shift + \`` | Move window to scratchpad |
| `Super + Mouse Scroll` | Switch to next / previous workspace |
| `Super + LMB (Drag)` | Move window |
| `Super + RMB (Drag)` | Resize window |

---

### Applications & Launchers
| Keybinding | Action |
|---|---|
| `Super + Space` | Application Launcher (Rofi drun) |
| `Super + Alt + Space` | System Control Hub (Rofi) |
| `Super + B` | Web Browser (Firefox default profile) |
| `Super + Shift + B` | Web Browser (Firefox secondary profile) |
| `Super + F` | Graphical File Manager (Thunar) |
| `Super + Y` | Terminal File Manager (Yazi) |
| `Super + V` | Clipboard History Manager (cliphist + Rofi) |
| `Super + Shift + ,` | Clear Clipboard History (`cliphist wipe`) |
| `Super + Shift + T` | Theme Switcher |
| `Super + Shift + W` | Wallpaper Gallery Selector |
| `Super + Escape` | Power Menu (Rofi) |
| `Super + Alt + L` | Lock screen immediately (Hyprlock) |

---

### Media & Screen Capture
| Keybinding | Action |
|---|---|
| `Print` | Screenshot (Select region to file & clipboard) |
| `Super + Shift + P` | Screenshot with Annotation (Swappy) |
| `Super + Shift + O` | OCR Text Grabber (Extract text from region) |
| `Super + Alt + R` | Screen Recording (Toggle fullscreen recording) |
| `Super + Shift + M` | Toggle Microphone Mute |
| `Volume / Brightness / Media Keys` | Audio Sinks, Brightness (OSD scripts), Playerctl controls |
| `Caps_Lock` | CapsLock Toggle + OSD Notification |

## Day-to-Day Maintenance

Aliases and shell utilities defined in `home/zsh.nix`:

### NixOS System Management
| Command | Description |
|---|---|
| `nrs` | Build and switch configuration (`sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)`) |
| `nrb` | Build configuration without switching (dry check) |
| `nfu` | Update flake inputs (`nix flake update`) in `~/.config/nixos` |

### Shell & Multiplexer
| Command | Description |
|---|---|
| `ta` | Attach to `main` tmux session or create if not running |
| `tls` | List active tmux sessions (`tmux ls`) |
| `y` | Yazi wrapper that automatically changes current directory on exit |
| `ll` / `la` | Modern file list with details, permissions, and git status (`eza -la`) |
| `tree` | Tree directory view (`eza --tree`) |
| `cat` | Syntax-highlighted output pager (`bat`) |

### AI & Local LLM (Docker GPU)
| Command | Description |
|---|---|
| `ollama <command>` | Auto-starts Docker container with NVIDIA GPU acceleration and executes Ollama commands (`run`, `list`, `pull`, etc.) |
| `ollama-stop` | Stops the Ollama Docker container to immediately release GPU VRAM |

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
