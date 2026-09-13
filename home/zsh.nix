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
      cat = "bat";
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)";
      nrb = "sudo nixos-rebuild build --flake ~/.config/nixos#$(hostname)";
      nfu = "cd ~/.config/nixos && nix flake update && cd -";
    };

    initContent = ''
    export STARSHIP_CONFIG="$HOME/.config/themes/current/starship.toml"
    [ -f "$HOME/.config/themes/current/shell.sh" ] && source "$HOME/.config/themes/current/shell.sh"

    if [[ -z "$TMUX" && -z "$VSCODE_INJECTION" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]]; then
        tmux attach -t main || tmux new -s main
    fi
    '';
  };
}
