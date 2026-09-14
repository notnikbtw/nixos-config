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
    };

    initContent = ''
    export STARSHIP_CONFIG="$HOME/.config/themes/current/starship.toml"
    [ -f "$HOME/.config/themes/current/shell.sh" ] && source "$HOME/.config/themes/current/shell.sh"

    # Yazi file manager wrapper with cwd persistence on quit
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }

    # Zoxide smart directory jumping (z)
    if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init zsh)"
    fi

    if [[ -z "$TMUX" && -z "$VSCODE_INJECTION" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]]; then
        tmux attach -t main || tmux new -s main
    fi
    '';
  };
}
