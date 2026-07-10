{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./binds.nix
    ./look.nix
    ./monitors.nix
    ./rules.nix
    ./services.nix
  ];

  config = lib.mkIf config.nerv.capabilities.desktop {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "hyprlang";

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "dolphin";
        "$fileManager2" = "kitty -e yazi";
        "$menu" = "dms ipc call spotlight toggle";
        "$browser" = "zen-beta";
        "$browser2" = "helium";
        "$editor" = "zeditor";
        "$chat" = "signal-desktop";
        "$chat2" = "vesktop";

        env = [
          "STEAM_FORCE_DESKTOPUI_SCALING,1.33"
          "NIXOS_OZONE_WL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "QT_QPA_PLATFORM,wayland"
        ];

        "exec-once" = [
          "hyprctl output create headless"
        ];
      };

      submaps = {
        passthrough = {
          settings = {
            bind = [ "SUPER, escape, submap, reset" ];
          };
        };
      };
    };

    # Hyprland-only fish abbreviations, moved out of home/common/shell.nix
    programs.fish.shellAbbrs = {
      monitors = "hyprctl monitors";
      clients = "hyprctl clients";
      reload-hypr = "hyprctl reload";
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      playerctl
      jq
    ];
  };
}
