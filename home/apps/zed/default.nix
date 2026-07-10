{
  config,
  lib,
  theme,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  programs.zed-editor = {
    enable = true;
    themes = {
      duskrose = builtins.fromJSON (builtins.readFile ./duskrose.json);
      dawnrose = builtins.fromJSON (builtins.readFile ./dawnrose.json);
    };
    userSettings.theme = "Base16 ${theme.palette.name}";
  };
}
