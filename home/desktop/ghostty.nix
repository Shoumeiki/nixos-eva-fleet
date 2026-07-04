{ config, ... }:
let
  inherit (config.lib.stylix) colors;
in
{
  programs.ghostty = {
    enable = true;

    themes.DuskRose = {
      background = colors.base00;
      foreground = colors.base05;
      cursor-color = colors.base05;
      selection-background = colors.base02;
      selection-foreground = colors.base05;

      palette = with colors.withHashtag; [
        "0=${base00}"
        "1=${base08}"
        "2=${base0B}"
        "3=${base0A}"
        "4=${base0D}"
        "5=${base0E}"
        "6=${base0C}"
        "7=${base05}"
        "8=${base03}"
        "9=${base08}"
        "10=${base0B}"
        "11=${base0A}"
        "12=${base0D}"
        "13=${base0E}"
        "14=${base0C}"
        "15=${base07}"
      ];
    };

    settings = {
      theme = "DuskRose";
      font-family = config.stylix.fonts.monospace.name;
      font-size = config.stylix.fonts.sizes.terminal;
      scrollback-limit = 10000000;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;
      window-padding-x = 2;
      window-padding-y = 2;
      window-padding-balance = true;
      background-opacity = config.stylix.opacity.terminal;
    };
  };
}
