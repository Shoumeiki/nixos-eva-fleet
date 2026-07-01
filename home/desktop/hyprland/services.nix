{ config, ... }:
let
  avatarsDir = "${config.home.homeDirectory}/Pictures/Avatars";
  defaultAvatar = "${avatarsDir}/default.png";
in
{
  stylix.targets.hyprlock.enable = false;

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
          blur_passes = 0;
          brightness = 0.5;
        }
      ];

      image = [
        {
          monitor = "";
          path = defaultAvatar;
          size = 200;
          rounding = -1;
          border_size = 2;
          position = "-300, 0";
          halign = "center";
          valign = "center";
          reload_cmd = "find ${avatarsDir} -type f 2>/dev/null | shuf -n 1";
          reload_time = -1;
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
          outline_thickness = 2;
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
          lock_cmd = "pidof hyprlock || hyprlock";
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
