# NixOS + Hyprland dotfiles

A modular NixOS configuration using flakes and home-manager, running Hyprland

## Stack

- **WM:** Hyprland
- **Bar:** Waybar
- **Launcher:** Rofi
- **Notifications:** Dunst
- **Lock/idle:** Hyprlock + Hypridle
- **Terminal:** Kitty
- **Shell:** Zsh + Starship
- **Multiplexer:** Tmux (auto-attached on new terminal)
- **Wallpaper:** hyprpaper
- **Theme:** Gruvbox, consistent across GTK/Qt/terminal/bar

## Structure

```
.
├── flake.nix
├── flake.lock
├── configuration.nix
├── hardware-configuration.nix       # NOT in repo - gitignored, generate your own
├── modules/
│   ├── nix.nix
│   ├── boot.nix
│   ├── networking.nix
│   ├── users.nix
│   ├── desktop.nix                  # greetd, Hyprland, pipewire, fonts
│   ├── programs.nix                 # steam, docker, thunar
│   ├── packages.nix                 # systemwide packages
│   └── laptop.nix                   # nixos-hardware profile, nvidia
└── home/
    ├── home.nix                     # imports everything below
    ├── hypr.nix + hypr/             # hyprland.lua, hypridle, hyprlock, wallpaper
    ├── waybar.nix + waybar/
    ├── rofi.nix + rofi/
    ├── dunst.nix + dunst/
    ├── kitty.nix
    ├── zsh.nix
    ├── tmux.nix
    ├── starship.nix
    ├── theme.nix                    # GTK/Qt/cursor, Gruvbox
    └── wallpaper.nix                # swww service
```

## Prerequisites

Nix with flakes enabled. On a fresh NixOS install, add to
`/etc/nixos/configuration.nix` before first switch (or use the installer's
flake support), or set in `nix.conf`:

```
experimental-features = nix-command flakes
```

## Installing on a new machine

1. Generate your own hardware config
```bash
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```
2. Clone this repo to `~/.config/nixos`:
```bash
   git clone <this-repo-url> ~/.config/nixos
```
3. Replace `hardware-configuration.nix` with the one generated in step 1.
4. Update the LUKS UUID in `modules/boot.nix` to match your own disk
   (find it with `blkid`).
5. Point `/etc/nixos` at the repo:
```bash
   sudo mv /etc/nixos /etc/nixos.bak
   sudo ln -s ~/.config/nixos /etc/nixos
```
6. Build:
```bash
   sudo nixos-rebuild switch --flake ~/.config/nixos#nixos
```

## Day-to-day usage

Aliases (defined in `home/zsh.nix`):

| Alias | Does |
|---|---|
| `nrb` | Build the config without applying (dry check) |
| `nrs` | Build and switch |
| `nfu` | `nix flake update` |

Full commands, if not using the aliases:

```bash
sudo nixos-rebuild build  --flake ~/.config/nixos#nixos
sudo nixos-rebuild switch --flake ~/.config/nixos#nixos
```

Update dependencies (nixpkgs, home-manager, nixos-hardware):

```bash
cd ~/.config/nixos
nix flake update
sudo nixos-rebuild switch --flake .#nixos
```

Roll back if something breaks:

```bash
sudo nixos-rebuild switch --rollback
```
