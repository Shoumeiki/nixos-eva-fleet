{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  c = theme.palette.hexH;
in
lib.mkIf config.nerv.capabilities.desktop {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    theme = {
      manager = {
        cwd = {
          fg = c.base0D;
        };
        hovered = {
          fg = c.base00;
          bg = c.base0D;
        };
        find_keyword = {
          fg = c.base0A;
          bold = true;
        };
        marker_selected = {
          fg = c.base0B;
        };
        marker_copied = {
          fg = c.base0A;
        };
        marker_cut = {
          fg = c.base08;
        };
        border_symbol = "│";
        border_style = {
          fg = c.base02;
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        mode_normal_fg = c.base00;
        mode_normal_bg = c.base0D;
        mode_select_fg = c.base00;
        mode_select_bg = c.base0B;
        mode_unset_fg = c.base00;
        mode_unset_bg = c.base0E;
        progress_label = c.base05;
        progress_normal = {
          fg = c.base0D;
          bg = c.base01;
        };
        progress_error = {
          fg = c.base08;
          bg = c.base01;
        };
        permissions_t = {
          fg = c.base0B;
        };
        permissions_r = {
          fg = c.base0A;
        };
        permissions_w = {
          fg = c.base08;
        };
        permissions_x = {
          fg = c.base0C;
        };
      };
    };
  };

  home.packages = with pkgs; [
    ouch
    ffmpegthumbnailer
    poppler
    fd
    ripgrep
  ];
}
