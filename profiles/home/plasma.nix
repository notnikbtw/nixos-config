{ pkgs, ... }:
{
  xdg.dataFile."color-schemes/Gruvbox.colors".source = "${pkgs.kde-gruvbox}/share/color-schemes/Gruvbox.colors";

  xdg.configFile."kxkbrc".text = ''
    [Layout]
    DisplayNames=,
    LayoutList=us,ua
    Use=true
    VariantList=,
  '';
}
