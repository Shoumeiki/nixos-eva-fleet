{ config, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
in
{
  programs.fish.functions.fastfetch = ''
    set -l avatars ~/Pictures/Avatars/*
    command fastfetch --logo-type kitty --logo (random choice $avatars) $argv
  '';

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "auto";
        padding = {
          top = 1;
          right = 2;
          left = 1;
        };
        height = 15;
      };
      modules = [
        "break"
        {
          type = "command";
          key = "  ";
          keyWidth = 2;
          text =
            let
              hex = builtins.substring 1 6 c.base03;
              r = builtins.substring 0 2 hex;
              g = builtins.substring 2 2 hex;
              b = builtins.substring 4 2 hex;
            in
            "printf -- '\\033[38;2;%d;%d;%dm──── %s@%s ─ 󰃮 %s ────\\033[0m' 0x${r} 0x${g} 0x${b} \"$USER\" \"$(hostname)\" \"$(date '+%d/%m/%Y %H:%M')\"";
        }
        "break"
        {
          type = "custom";
          format = "[90m┌──────────────────Hardware──────────────────┐";
        }
        {
          type = "title";
          key = " 󰌢  PC";
          format = "{host-name}";
          keyColor = c.base08;
        }
        {
          type = "cpu";
          key = " │ ├ ";
          format = "{1} @ {7}";
          keyColor = c.base08;
        }
        {
          type = "gpu";
          key = " │ ├󰾲 ";
          hideType = "integrated";
          format = "{1} {2}";
          keyColor = c.base08;
        }
        {
          type = "memory";
          key = " │ ├󰑭 ";
          keyColor = c.base08;
        }
        {
          type = "disk";
          key = " │ ├󰋊 ";
          format = "{1} / {2} ({3})";
          keyColor = c.base08;
        }
        {
          type = "command";
          key = " │ ├󰍹 ";
          text = "hyprctl monitors -j | jq -r '.[] | select(.name==\"DP-1\") | \"\\(.width)x\\(.height), \\(.refreshRate | floor)Hz\"'";
          keyColor = c.base08;
        }
        {
          type = "command";
          key = " │ ├󱡶 ";
          text = "hyprctl monitors -j | jq -r '.[] | select(.name==\"HDMI-A-1\") | \"\\(.width)x\\(.height), \\(.refreshRate | floor)Hz\"'";
          keyColor = c.base08;
        }
        {
          type = "localip";
          key = " │ ├󰲝 ";
          keyColor = c.base08;
        }
        {
          type = "uptime";
          key = " └ └ ";
          keyColor = c.base08;
        }
        {
          type = "custom";
          format = "[90m└────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "[90m┌──────────────────Software──────────────────┐";
        }
        {
          type = "os";
          key = "   OS";
          keyColor = c.base09;
        }
        {
          type = "kernel";
          key = " │ ├ ";
          keyColor = c.base09;
        }
        {
          type = "packages";
          key = " │ ├󰏖 ";
          keyColor = c.base09;
        }
        {
          type = "shell";
          key = " │ ├󰞷 ";
          keyColor = c.base09;
        }
        {
          type = "command";
          key = " └ └󱦟 ";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          keyColor = c.base09;
        }
        "break"
        {
          type = "de";
          key = " 󰧨  DE";
          keyColor = c.base09;
        }
        {
          type = "wm";
          key = "   WM";
          keyColor = c.base09;
        }
        {
          type = "lm";
          key = " │ ├ ";
          format = "{1}";
          keyColor = c.base09;
        }
        {
          type = "wmtheme";
          key = " │ ├󰉦 ";
          keyColor = c.base09;
        }
        {
          type = "terminal";
          key = " │ ├󰆍 ";
          keyColor = c.base09;
        }
        {
          type = "terminalfont";
          key = " └ └ ";
          format = "{1}";
          keyColor = c.base09;

        }
        {
          type = "custom";
          format = "[90m└────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 15;
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
