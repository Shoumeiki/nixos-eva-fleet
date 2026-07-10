{
  config,
  lib,
  pkgs,
  ...
}:
let
  randomWallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    set -eu
    DIR="$HOME/Pictures/Wallpapers"
    if [ ! -d "$DIR" ]; then
      echo "random-wallpaper: $DIR does not exist" >&2
      exit 0
    fi
    WALL=$(${pkgs.findutils}/bin/find "$DIR" -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
      | ${pkgs.coreutils}/bin/shuf -n 1)
    if [ -z "$WALL" ]; then
      echo "random-wallpaper: no images found in $DIR" >&2
      exit 0
    fi
    # Wait for hyprpaper's IPC socket instead of guessing a fixed delay
    SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.hyprpaper.sock"
    for _ in $(seq 1 50); do
      [ -S "$SOCK" ] && break
      sleep 0.1
    done
    # "wallpaper" is the only hyprpaper request hyprctl exposes now — it
    # loads and applies in one call, no separate "preload" needed
    hyprctl hyprpaper wallpaper ",$WALL"
  '';
in
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
        "$menu" = "rofi -show drun";
        "$browser" = "zen-beta";
        "$browser2" = "helium";
        "$editor" = "zeditor";
        "$chat" = "signal-desktop";
        "$chat2" = "vesktop";
        "$powerMenu" = "wlogout";

        env = [
          "STEAM_FORCE_DESKTOPUI_SCALING,1.33"
          "NIXOS_OZONE_WL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "QT_QPA_PLATFORM,wayland"
        ];

        "exec-once" = [
          "hyprctl output create headless"
          "${lib.getExe randomWallpaper}"
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
      cliphist
      playerctl
      jq
      wlogout
      randomWallpaper
    ];
  };
}
