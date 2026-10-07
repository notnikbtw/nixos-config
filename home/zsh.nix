{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      tree = "eza --tree";
      cat = "bat";
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)";
      nrb = "sudo nixos-rebuild build --flake ~/.config/nixos#$(hostname)";
      nfu = "cd ~/.config/nixos && nix flake update && cd -";
      ta = "tmux attach -t main || tmux new -s main";
      tls = "tmux ls";
      ollama-stop = "docker stop ollama";
      ff = "firefox &";
      ff2 = "firefox -P secondary --no-remote &";
    };

    initContent = ''
    export STARSHIP_CONFIG="$HOME/.config/themes/current/starship.toml"
    [ -f "$HOME/.config/themes/current/shell.sh" ] && source "$HOME/.config/themes/current/shell.sh"

    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }

    function ollama() {
        if ! docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^ollama$'; then
            if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q '^ollama$'; then
                echo "Starting existing Ollama container..."
                docker start ollama >/dev/null
            else
                echo "Launching Ollama container with NVIDIA GPU..."
                docker run -d --gpus=all -v ollama:/root/.ollama -p 127.0.0.1:11434:11434 --name ollama --restart no ollama/ollama >/dev/null
            fi
        fi
        docker exec -it ollama ollama "$@"
    }

    if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init zsh)"
    fi
    '';
  };
}
