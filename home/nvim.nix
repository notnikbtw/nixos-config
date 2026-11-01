{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    # Web: TypeScript, JavaScript, React, Next.js, NestJS
    typescript-language-server
    vscode-langservers-extracted # html, css, json, eslint
    tailwindcss-language-server
    prettier
    # Go
    gopls
    gotools # goimports
    # Config and tooling
    lua-language-server
    stylua
    tree-sitter
  ];

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
