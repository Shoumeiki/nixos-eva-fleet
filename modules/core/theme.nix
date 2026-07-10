# NixOS-level (non-home-manager) theming: console/limine/plymouth plus the
# global font/cursor install. Uses the same plain-data palette everything
# else reads (home/lib/palettes.nix).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  palettes = import ../../home/lib/palettes.nix;
  tokens = import ../../home/lib/tokens.nix;
  c = palettes.${config.nerv.theme.active}.colors;
  resolvePkg = path: lib.getAttrFromPath (lib.splitString "." path) pkgs;

  # Same base16 -> ANSI-16 ordering used by home/apps/kitty's palette.
  ansi16 = [
    c.base00
    c.base08
    c.base0B
    c.base0A
    c.base0D
    c.base0E
    c.base0C
    c.base05
    c.base03
    c.base08
    c.base0B
    c.base0A
    c.base0D
    c.base0E
    c.base0C
    c.base07
  ];
in
{
  console.colors = ansi16;

  boot.loader.limine.style = {
    backdrop = c.base00;
    wallpaperStyle = "stretched";
    graphicalTerminal = {
      background = c.base00;
      foreground = c.base05;
      palette = lib.concatStringsSep ";" [
        c.base05
        c.base08
        c.base0B
        c.base0A
        c.base0D
        c.base0E
        c.base0C
        c.base00
      ];
      brightPalette = lib.concatStringsSep ";" [
        c.base00
        c.base08
        c.base0B
        c.base0A
        c.base0D
        c.base0E
        c.base0C
        c.base05
      ];
    };
  };

  # A themed boot splash is fiddly to get right; a stock theme is a
  # deliberate simplification. Revisit with a custom themed package later.
  boot.plymouth.theme = "bgrt";

  fonts.packages = [
    (resolvePkg tokens.fonts.monospace.package)
    (resolvePkg tokens.fonts.sansSerif.package)
    (resolvePkg tokens.fonts.serif.package)
    (resolvePkg tokens.fonts.emoji.package)
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ tokens.fonts.monospace.name ];
    sansSerif = [ tokens.fonts.sansSerif.name ];
    serif = [ tokens.fonts.serif.name ];
    emoji = [ tokens.fonts.emoji.name ];
  };
}
