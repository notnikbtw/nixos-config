{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo.padding.right = 2;
      display.separator = "  ";
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
        "terminal"
        "break"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
        "break"
        "colors"
      ];
    };
  };
}
