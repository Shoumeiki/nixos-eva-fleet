{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nerv.capabilities.creative {
  home.packages = [ pkgs.pinta ];
}
