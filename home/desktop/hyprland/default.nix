{ lib, pkgs, ... }:
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
    hyprctl hyprpaper preload "$WALL"
    hyprctl hyprpaper wallpaper ",$WALL"
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

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "hyprlang";

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";
      "$browser" = "zen-beta";
      "$browser2" = "helium";
      "$editor" = "zeditor";
      "$chat" = "signal-desktop";
      "$powerMenu" = "wlogout";

      env = [
        "STEAM_FORCE_DESKTOPUI_SCALING,1.33"
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
      ];

      "exec-once" = [
        "hyprctl output create headless"
        "sleep 1 && ${lib.getExe randomWallpaper}"
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
}
