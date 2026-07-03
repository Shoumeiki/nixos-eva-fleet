_: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0;
      accel_profile = "flat";
    };
    xwayland.force_zero_scaling = true;

    # Cursor
    cursor = {
      inactive_timeout = 5;
      no_warps = true;
    };

    # Look
    general = {
      gaps_in = 6;
      gaps_out = 10;
      border_size = 2;
      layout = "dwindle";
      allow_tearing = true;
      resize_on_border = true;
    };
    decoration = {
      rounding = 8;
      blur = {
        enabled = true;
        size = 6;
        passes = 2;
        new_optimizations = true;
      };
      shadow = {
        enabled = true;
        range = 8;
        render_power = 3;
      };
    };

    # Animations
    animations = {
      enabled = true;
      bezier = [
        "snappy, 0.25, 1.0, 0.5, 1.0"
      ];
      animation = [
        "windows, 1, 3, snappy, popin 80%"
        "windowsOut, 1, 3, snappy, popin 80%"
        "border, 1, 5, default"
        "borderangle, 1, 8, default"
        "fade, 1, 3, default"
        "workspaces, 1, 3, snappy"
      ];
    };

    dwindle = {
      preserve_split = true;
      smart_split = false;
    };

    debug.vfr = true;
    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      enable_swallow = true;
      swallow_regex = "^(ghostty)$";
      focus_on_activate = true;
      on_focus_under_fullscreen = 2;
    };
  };
}
