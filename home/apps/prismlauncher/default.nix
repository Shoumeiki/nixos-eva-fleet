{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nerv.capabilities.gaming {
  home.packages = [ pkgs.prismlauncher ];
}
