{ pkgs, inputs, ... }:
{
  environment.systemPackages = (with pkgs; [
    telegram-desktop
    librewolf
    wget
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
    exiftool
    mat2

    hyprlock
    awww
    hyprsunset
    (rofi.override { plugins = [ rofi-calc ]; })
    libqalculate
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
    syncthingtray
    pavucontrol
    file-roller

    eza
    bat
    ripgrep
    fd
    hyfetch
    fortune
    zoxide
    fzf
    jq

    vscode
    go
    nodejs_24
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
