# NixOS dotfiles

<a href="https://portfolio-notnikbtw.vercel.app/" target="_blank" rel="noopener noreferrer">
  <img src="https://portfolio-notnikbtw.vercel.app/buttons/notnik.png" alt="!Nik - 88x31 Button" width="88" height="31" />
</a>

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
[![WM - Hyprland](https://img.shields.io/badge/WM-Hyprland-58E6D9.svg?logo=hyprland&logoColor=black)](https://hyprland.org)
[![License - MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

My personal modular NixOS configuration for desktop and laptop running Hyprland

## Hosts

| Host      | Hardware                                      | Profile Details |
|-----------|-----------------------------------------------|-----------------|
| `laptop`  | Lenovo IdeaPad 5 Pro (Ryzen 5000 / RTX 3050M) | 2.5K 120Hz, battery profiles, scaled UI |
| `desktop` | Intel i5 / RTX 3080                           | 2x 1440p @ 165Hz, compact UI |

## Stack

- **Login & Session:** greetd + tuigreet
- **Window Manager:** Hyprland (Lua config)
- **Status Bar, Notifications & OSD:** Quickshell
- **Application Launcher & Hub:** Rofi Wayland
- **Screen Locker & Idle:** Hyprlock + Hypridle
- **Terminal:** Kitty (GPU-accelerated, FiraCode Nerd Font)
- **Shell & Prompt:** Zsh + Starship
- **Multiplexer:** Tmux (truecolor, manual session management via `ta` / `tls`)
- **Screen Recording & Capture:** `wf-recorder` (NVIDIA DMA-BUF buffer support), Grim, Slurp, Swappy
- **Storage:** Btrfs on LUKS (zstd compression, `noatime`, monthly scrub), Snapper snapshots of `/home`, zram swap
- **AI Stack:** Docker Ollama, `llm-agents.nix` (`opencode`, `antigravity-cli`, `claude-code`)
- **Wallpaper Daemon:** `awww`
- **Dynamic Theming:** Instant switching across GTK, Qt, Kitty, Quickshell, Starship, Btop, Rofi, and Hyprland (Gruvbox, Kanagawa, Miasma)

## Declarative Per-Host UI Scaling

- `home/settings.nix` defines the font families (`fontFamily`, `uiFontFamily`) and the size profiles (`profiles.desktop`, `profiles.laptop`).
- Home Manager selects a profile based on the hostname and passes the fonts and sizes to programs such as Kitty and Rofi, etc., so font names are specified in only one place.
- Other per-host differences live in `hosts/<hostname>/`

## Keybindings

All keybindings (main modifier: `Super`) are defined in [`home/hypr/lua/binds.lua`](home/hypr/lua/binds.lua).

## Storage & Snapshots

Defined in [`modules/filesystems.nix`](modules/filesystems.nix): `compress=zstd` and `noatime` on `/`, `/home` and `/nix`, a monthly `btrfs scrub` (`sudo btrfs scrub status /`), and hourly read-only Snapper snapshots of `/home`. A daily cleanup keeps:

| Host | Hourly | Daily | Weekly | Goes back |
|---|---|---|---|---|
| `desktop` | 24 | 14 | 4 | ~1 month |
| `laptop` | 12 | 7 | 0 | 1 week |

Snapshot Management

```bash
sudo snapper -c home list                                          # find the snapshot <number>
sudo cp -a /home/.snapshots/<number>/snapshot/$USER/path/to/file ~/path/to/   # restore, keeping your ownership
sudo snapper -c home create -d "before cleanup"                    # manual snapshot (never auto-deleted)
sudo snapper -c home delete <number>
```

**Excluding folders:** nested Btrfs subvolumes are not part of snapshots. Re-downloadable data is excluded by turning its folder into a subvolume, with the app closed:
```bash
cd ~/.local/share/Steam/steamapps
for d in common shadercache; do
  mv "$d" "$d.old" && btrfs subvolume create "$d" && cp -a --reflink=always "$d.old/." "$d/"
done
# check that games launch, then: rm -rf common.old shadercache.old
```
`steamapps/compatdata` stays included, because Proton games keep their save files there.

## Aliases

Defined in [`home/zsh.nix`](home/zsh.nix):

| Command | Description |
|---|---|
| `nrs` | Build and switch (`sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)`) |
| `nrb` | Build without switching, to check that the configuration builds |
| `nfu` | Update flake inputs (`nix flake update`) |
| `ta` / `tls` | Attach to (or create) the `main` tmux session / list sessions |
| `y` | Yazi that changes the current directory on exit |
| `ll` / `la` / `tree` | `eza` listings with details and git status / tree view |
| `cat` | `bat` with syntax highlighting |
| `ollama <command>` | Starts the Ollama container (NVIDIA GPU, API on `127.0.0.1:11434`) and runs the command |
| `ollama-stop` | Stops the container and frees GPU VRAM |

Roll back to the previous generation with `sudo nixos-rebuild switch --rollback`.

## Installing on a New Machine

1. Clone the repository:
   ```bash
   nix-shell -p git --run "git clone https://github.com/notnikbtw/nixos-config.git ~/.config/nixos"
   ```
2. Create `hosts/<hostname>/` with a `configuration.nix` and `gpu.nix` (copy an existing host), and register it in `flake.nix`:
   ```nix
   <hostname> = mkHost { hostname = "<hostname>"; };
   ```
3. Generate the hardware configuration (disks, LUKS, kernel modules) and add the new files to git, since flakes only see tracked files:
   ```bash
   cd ~/.config/nixos
   sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   nix-shell -p git --run "git add hosts/<hostname> flake.nix"
   ```
4. Build and activate (flakes are not enabled yet on a fresh install):
   ```bash
   sudo env NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake ~/.config/nixos#<hostname>
   ```
5. Log out and back in so the Hyprland session and portals start. `/home/.snapshots` is created automatically; exclude Steam games before the first snapshots if needed (see [Storage & Snapshots](#storage--snapshots)).

## Contributing

Issues, ideas and pull requests are very welcome :3 

Feel free to steal any scripts, modules, or keybindings for your own configuration!

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
