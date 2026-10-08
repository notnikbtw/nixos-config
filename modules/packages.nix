{ pkgs, inputs, ... }:
{
  environment.systemPackages = (with pkgs; [
    telegram-desktop
    wget
    btop
    imv
    p7zip
    unzip
    zip
    ffmpegthumbnailer
    webp-pixbuf-loader
    librsvg
    mpv
    yazi
    vesktop
    obsidian
    prismlauncher
    libreoffice

    hyprlock
    awww
    hyprsunset
    quickshell
    rofi
    libnotify
    grim
    slurp
    swappy
    wf-recorder
    tesseract
    wtype
    brightnessctl
    playerctl
    networkmanagerapplet
    blueman
    syncthingtray
    pavucontrol
    file-roller

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
    act
    gh

    hicolor-icon-theme
  ]) ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    antigravity-cli
    claude-code
  ]);
}
