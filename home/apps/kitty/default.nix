{
  config,
  lib,
  theme,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  programs.kitty = {
    enable = true;

    font = {
      name = theme.fonts.monospace.name;
      size = theme.fonts.sizes.terminal;
    };

    shellIntegration.enableFishIntegration = true;

    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+d" = "new_window_with_cwd";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
    };

    settings = {
      background = theme.palette.hexH.base00;
      foreground = theme.palette.hexH.base05;
      cursor = theme.palette.hexH.base05;
      selection_background = theme.palette.hexH.base02;
      selection_foreground = theme.palette.hexH.base05;

      color0 = theme.palette.hexH.base00;
      color1 = theme.palette.hexH.base08;
      color2 = theme.palette.hexH.base0B;
      color3 = theme.palette.hexH.base0A;
      color4 = theme.palette.hexH.base0D;
      color5 = theme.palette.hexH.base0E;
      color6 = theme.palette.hexH.base0C;
      color7 = theme.palette.hexH.base05;
      color8 = theme.palette.hexH.base03;
      color9 = theme.palette.hexH.base08;
      color10 = theme.palette.hexH.base0B;
      color11 = theme.palette.hexH.base0A;
      color12 = theme.palette.hexH.base0D;
      color13 = theme.palette.hexH.base0E;
      color14 = theme.palette.hexH.base0C;
      color15 = theme.palette.hexH.base07;

      scrollback_lines = 10000;
      confirm_os_window_close = 0;
      mouse_hide_wait = "3.0";
      window_padding_width = 24;
      background_opacity = theme.opacity.terminal;

      # Native splits/tabs reduce the need for a separate multiplexer.
      enabled_layouts = "splits,stack,tall,grid";

      shell_integration = "enabled";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty-{kitty_pid}";
    };
  };
}
