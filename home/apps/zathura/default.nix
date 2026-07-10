{
  config,
  lib,
  theme,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#${theme.palette.hex.base00}";
      default-fg = "#${theme.palette.hex.base05}";
      statusbar-bg = "#${theme.palette.hex.base01}";
      statusbar-fg = "#${theme.palette.hex.base05}";
      inputbar-bg = "#${theme.palette.hex.base01}";
      inputbar-fg = "#${theme.palette.hex.base05}";
      notification-bg = "#${theme.palette.hex.base01}";
      notification-fg = "#${theme.palette.hex.base05}";
      notification-error-bg = "#${theme.palette.hex.base01}";
      notification-error-fg = "#${theme.palette.hex.base08}";
      notification-warning-bg = "#${theme.palette.hex.base01}";
      notification-warning-fg = "#${theme.palette.hex.base0A}";
      completion-bg = "#${theme.palette.hex.base01}";
      completion-fg = "#${theme.palette.hex.base05}";
      completion-highlight-bg = "#${theme.palette.hex.base02}";
      completion-highlight-fg = "#${theme.palette.hex.base0D}";
      highlight-color = "#${theme.palette.hex.base0A}";
      highlight-active-color = "#${theme.palette.hex.base0D}";
      recolor = true;
      recolor-lightcolor = "#${theme.palette.hex.base00}";
      recolor-darkcolor = "#${theme.palette.hex.base05}";
    };
  };
}
