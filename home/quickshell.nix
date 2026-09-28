{ config, ... }:
{
  xdg.configFile."quickshell/bar".source = ./quickshell/bar;
  xdg.configFile."quickshell/notifications".source = ./quickshell/notifications;
  xdg.configFile."quickshell/osd".source = ./quickshell/osd;
  xdg.configFile."quickshell/scripts".source = ./quickshell/scripts;
  xdg.configFile."quickshell/qmldir".source = ./quickshell/qmldir;
  xdg.configFile."quickshell/shell.qml".source = ./quickshell/shell.qml;

  xdg.configFile."quickshell/FontConfig.qml".text = ''
    pragma Singleton
    import QtQuick

    QtObject {
        property string family: "${config.hostSettings.fontFamily}"
        property int sizeNormal: ${toString config.hostSettings.fontSize}
        property int sizeSmall: ${toString config.hostSettings.fontSizeSmall}
        property int barHeight: ${toString config.hostSettings.barHeight}
    }
  '';
}