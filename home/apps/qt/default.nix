# Follow GTK rather than maintaining a separate Kvantum/qt theme.
{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
