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
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";
      nrb = "sudo nixos-rebuild build --flake ~/.config/nixos#nixos";
      nfu = "cd ~/.config/nixos && nix flake update && cd -";
    };

    initContent = ''
    if [[ -z "$TMUX" && -z "$VSCODE_INJECTION" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]]; then
        tmux attach -t main || tmux new -s main
    fi
    '';
  };
}
