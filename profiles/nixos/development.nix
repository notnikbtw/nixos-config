{ pkgs, inputs, ... }:
{
  environment.systemPackages = (with pkgs; [
    vscode
    go
    nodejs_24
    pnpm
    python3
    gcc
    gnumake
    git
    docker-compose
    postgresql
    act
    gh
  ]) ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    codex
    claude-code
  ]);
}
