{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Apps
    firefox
    wget
    btop
    imv
    p7zip
    unzip
    mpv
    yazi
    thunar
    vesktop
    obsidian
    prismlauncher

    # Hyprland environment
    hyprlock
    hypridle
    hyprpaper
    waybar
    rofi
    dunst
    wl-clipboard
    grim
    slurp
    cliphist
    hyprpicker
    brightnessctl
    networkmanagerapplet
    pavucontrol
    wireplumber
    swappy
    file-roller

    # Terminal
    zsh
    starship
    tmux
    kitty
    eza
    bat
    ripgrep
    fd
    fastfetch
    hyfetch

    # Dev environment
    vscode
    go
    nodejs_22
    git
    neovim
    docker-compose
    postgresql
    antigravity

    adwaita-icon-theme
    papirus-icon-theme
    hicolor-icon-theme
    bibata-cursors
  ];
}
