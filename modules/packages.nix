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
    zip
    ffmpegthumbnailer
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
    hyprpolkitagent
    awww
    (pkgs.writeShellScriptBin "swww" ''exec ${pkgs.awww}/bin/awww "$@"'')
    (pkgs.writeShellScriptBin "swww-daemon" ''exec ${pkgs.awww}/bin/awww-daemon "$@"'')
    hyprsunset
    quickshell
    rofi
    libnotify
    wl-clipboard
    grim
    slurp
    swappy
    wl-screenrec
    wf-recorder
    tesseract
    qrencode
    wtype
    cliphist
    hyprpicker
    hyprshade
    brightnessctl
    playerctl
    networkmanagerapplet
    blueman
    bluez
    syncthingtray
    pavucontrol
    wireplumber
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
    zoxide
    fzf
    jq

    # Dev environment
    vscode
    go
    nodejs_22
    pnpm
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
