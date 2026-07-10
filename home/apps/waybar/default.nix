{
  config,
  lib,
  theme,
  ...
}:
let
  c = theme.palette.hexH;
  font = theme.fonts.sansSerif.name;
  fontSize = theme.fonts.sizes.desktop * 3 / 2;

  monitors = config.nerv.hardware.monitors;
  primaryOutput = (lib.findFirst (m: m.primary) { output = "DP-1"; } monitors).output;
  secondaryOutput = (lib.findFirst (m: !m.primary) { output = "HDMI-A-1"; } monitors).output;
  isAmd = config.nerv.hardware.gpu.vendor == "amd";

  # GTK's CSS parser rejects #RRGGBBAA — build rgba() from a hex color
  # and a 0.0-1.0 opacity value instead.
  hexMap = lib.listToAttrs (
    lib.imap0 (i: ch: lib.nameValuePair ch i) (lib.stringToCharacters "0123456789abcdef")
  );
  hexPairVal =
    pair: hexMap.${builtins.substring 0 1 pair} * 16 + hexMap.${builtins.substring 1 1 pair};
  rgba =
    hex: opacity:
    "rgba(${toString (hexPairVal (builtins.substring 0 2 hex))}, ${
      toString (hexPairVal (builtins.substring 2 2 hex))
    }, ${toString (hexPairVal (builtins.substring 4 2 hex))}, ${toString opacity})";
  pillBg = rgba theme.palette.hex.base01 theme.opacity.desktop;
  activeBg = rgba theme.palette.hex.base02 theme.opacity.desktop;
in
lib.mkIf config.nerv.capabilities.desktop {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      * {
        font-family: "${font}", "JetBrainsMono Nerd Font";
        font-size:   ${toString fontSize}px;
        border:      none;
        box-shadow:  none;
        min-height:  0;
      }

      window#waybar {
        background-color: transparent;
      }

      /* Floating pill segments */
      .modules-left,
      .modules-center,
      .modules-right {
        background-color: ${pillBg};
        border-radius:    9999px;
        margin:           8px 4px;
        padding:          6px 18px;
      }

      .modules-left  { margin-left:  8px; }
      .modules-right { margin-right: 8px; }

      /* Workspace pill buttons */
      #workspaces button {
        color:         ${c.base04};
        padding:       2px 10px;
        border-radius: 9999px;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background-color: ${activeBg};
        color:            ${c.base05};
      }

      #workspaces button:hover {
        background-color: ${activeBg};
        color:            ${c.base05};
      }

      /* Module colours */
      #clock                    { color: ${c.base05}; font-weight: bold; }
      #cpu                      { color: ${c.base0B}; }
      #memory                   { color: ${c.base0D}; }
      #pulseaudio               { color: ${c.base09}; }
      #pulseaudio.muted         { color: ${c.base03}; }
      #bluetooth                { color: ${c.base0C}; }
      #bluetooth.disabled,
      #bluetooth.off            { color: ${c.base03}; }
      #network                  { color: ${c.base0B}; }
      #network.disconnected     { color: ${c.base08}; }
      #idle_inhibitor           { color: ${c.base03}; }
      #idle_inhibitor.activated { color: ${c.base0A}; }
      #custom-gpu               { color: ${c.base0E}; }
      #custom-gpu-temp          { color: ${c.base0E}; }
      #custom-clipboard         { color: ${c.base0D}; padding: 0 4px; }
      #custom-theme-toggle      { color: ${c.base0A}; }
      #submap                   { color: ${c.base0A}; font-weight: bold; }

      #tray > .passive         { -gtk-icon-effect: dim;       }
      #tray > .needs-attention { -gtk-icon-effect: highlight; }
    '';

    settings = {
      primary = {
        output = primaryOutput;
        layer = "top";
        position = "top";
        height = 0;
        "margin-top" = 8;
        spacing = 8;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "idle_inhibitor"
          "custom/theme-toggle"
          "custom/clipboard"
          "tray"
          "pulseaudio"
          "bluetooth"
          "network"
          "cpu"
          "memory"
        ]
        ++ lib.optionals isAmd [
          "custom/gpu"
          "custom/gpu-temp"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/submap" = {
          format = " {}";
          max-length = 16;
          tooltip = false;
        };

        clock = {
          format = "{:%H:%M  %a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
          tooltip = true;
        };

        "custom/clipboard" = {
          format = "󰅇";
          on-click = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          tooltip = true;
          tooltip-format = "Clipboard history";
        };

        "custom/theme-toggle" = {
          exec = "nerv-theme-toggle --status";
          interval = "once";
          signal = 8;
          on-click = "kitty --title theme-toggle -e nerv-theme-toggle";
          tooltip = true;
          tooltip-format = "Toggle DuskRose/DawnRose (rebuilds system)";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "muted ";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-disabled = " off";
          format-off = " off";
          on-click = "blueman-manager";
        };

        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "  {ifname}";
          format-disconnected = "no network";
          tooltip-format = "{ipaddr} via {gwaddr}";
          on-click = "nm-connection-editor";
        };

        cpu = {
          format = "CPU {usage}%";
          interval = 5;
        };

        memory = {
          format = "RAM {percentage}%";
          interval = 5;
        };
      }
      // lib.optionalAttrs isAmd {
        "custom/gpu" = {
          format = "GPU {}%";
          exec = "cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo N/A";
          interval = 5;
          tooltip = false;
        };

        "custom/gpu-temp" = {
          format = " {}°";
          exec = "sensors 'amdgpu-pci-*' 2>/dev/null | awk '/edge/ {gsub(/[+°C]/, \"\", $2); print $2; exit}' || echo N/A";
          interval = 10;
          tooltip = false;
        };
      }
      // {
        tray.spacing = 10;
      };

      secondary = {
        output = secondaryOutput;
        layer = "top";
        position = "top";
        height = 0;
        "margin-top" = 8;
        spacing = 8;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "clock" ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 80;
          separate-outputs = true;
        };

        clock.format = "{:%H:%M}";
      };
    };
  };
}
