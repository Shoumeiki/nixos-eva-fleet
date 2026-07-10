{
  config,
  pkgs,
  lib,
  theme,
  ...
}:
let
  avatarsDir = "${config.home.homeDirectory}/Pictures/Avatars";
  defaultAvatar = "${avatarsDir}/default.jpg";
  # hyprlock's color options take rgb(RRGGBB), not "#hex"
  rgb = hex: "rgb(${hex})";
  colors = theme.palette.hex;

  # hyprlock has no native hyprpaper integration, so resolve the
  # currently-active wallpaper via IPC and hand it to hyprlock through
  # an env var ($WALLPAPER is expanded by hyprlang at config parse time)
  hyprlockWrapper = pkgs.writeShellScriptBin "hyprlock-wrapper" ''
    set -eu
    WALLPAPER=$(hyprctl hyprpaper listactive 2>/dev/null \
      | ${pkgs.gawk}/bin/awk -F': ' 'NR==1 {print $2}')
    export WALLPAPER="''${WALLPAPER:-${defaultAvatar}}"

    AVATAR=$(${pkgs.findutils}/bin/find ${avatarsDir} -type f 2>/dev/null \
      | ${pkgs.coreutils}/bin/shuf -n 1)
    export AVATAR="''${AVATAR:-${defaultAvatar}}"

    exec ${config.programs.hyprlock.package}/bin/hyprlock
  '';
in
lib.mkIf config.nerv.capabilities.desktop {
  home.packages = [ hyprlockWrapper ];

  # Lock screen
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
          blur_size = 4;
          noise = 0.02;
          contrast = 0.9;
          brightness = 0.6;
        }
      ];

      image = [
        {
          monitor = "";
          path = "$AVATAR";
          size = 200;
          rounding = 8;
          border_size = 2;
          position = "-300, 0";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "Logged in as $USER";
          font_size = 16;
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          position = "0, 0";
          halign = "center";
          valign = "center";
          rounding = 8;
          outline_thickness = 2;
          inner_color = rgb colors.base01;
          outer_color = rgb colors.base0D;
          check_color = rgb colors.base0B;
          fail_color = rgb colors.base08;
          font_color = rgb colors.base05;
          placeholder_color = rgb colors.base03;
          dots_size = 0.25;
          dots_spacing = 0.3;
          fade_on_empty = false;
          placeholder_text = "Password";
          hide_input = false;
        }
      ];
    };
  };

  services = {
    # Idle daemon
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock-wrapper";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
        ];
      };
    };

    # Wallpaper daemon
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
      };
    };

    # Clipboard daemon
    cliphist.enable = true;

    # GUI polkit agent
    hyprpolkitagent.enable = true;

    # Gnome-keyring user services
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
