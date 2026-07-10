{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  home.packages = [ pkgs.signal-desktop ];
}
