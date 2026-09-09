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
    libreoffice

    # Hyprland environment
    hyprlock
    hypridle
    hyprpaper
    hyprpolkitagent
    quickshell
    rofi
    walker
    libnotify
    wl-clipboard
    grim
    slurp
    swappy
    wl-screenrec
    wf-recorder
    tesseract
    wtype
    cliphist
    hyprpicker
    hyprshade
    brightnessctl
    playerctl
    networkmanagerapplet
    blueman
    pavucontrol
    wireplumber
    file-roller
    swayosd

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
    zoxide
    fzf

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
    act
    llmfit

    adwaita-icon-theme
    papirus-icon-theme
    hicolor-icon-theme
  ]) ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    antigravity-cli
  ]);
}
