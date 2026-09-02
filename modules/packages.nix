{ pkgs, inputs, ... }:
{
  environment.systemPackages = (with pkgs; [
    # Apps
    firefox
    telegram-desktop
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
    hyprpolkitagent
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
    fortune
    cowsay
    cbonsai

    # Dev environment
    vscode
    go
    nodejs_22
    python3
    gcc
    gnumake
    git
    neovim
    docker-compose
    postgresql
    antigravity
    ollama

    adwaita-icon-theme
    papirus-icon-theme
    hicolor-icon-theme
  ]) ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    antigravity-cli
  ]);
}
