# Dolphin has no running Plasma/kded session to feed it theme info here, so
# it reads icon/color-scheme straight out of kdeglobals — kept in sync with
# home/apps/gtk's icon theme choice and theme.dark so it tracks the active
# palette instead of drifting from GTK.
{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  iconThemeName = if theme.dark then "Papirus-Dark" else "Papirus";
  colorScheme = if theme.dark then "BreezeDark" else "BreezeClassic";
in
lib.mkIf config.nerv.capabilities.desktop {
  home.packages = with pkgs.kdePackages; [
    dolphin
    kio-extras
    dolphin-plugins
    ffmpegthumbs
    kimageformats
  ];

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=${iconThemeName}

    [General]
    ColorScheme=${colorScheme}
  '';
}
