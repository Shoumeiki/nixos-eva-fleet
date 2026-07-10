{
  config,
  lib,
  theme,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      max-history = 50;
      layer = "overlay";
      margin = 10;
      padding = 12;
      background-color = "#${theme.palette.hex.base01}";
      text-color = "#${theme.palette.hex.base05}";
      border-color = "#${theme.palette.hex.base0D}";
    };
  };
}
