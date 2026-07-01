{ pkgs, ... }:
let
  palette = {
    dark = {
      # DuskRosé theme
      base00 = "1c1618";
      base01 = "262023";
      base02 = "3a3033";
      base03 = "5c4d52";
      base04 = "8f7e83";
      base05 = "d8ccd0";
      base06 = "eadde1";
      base07 = "f5ecef";
      base08 = "e78ba5";
      base09 = "8ab5d4";
      base0A = "e0c098";
      base0B = "a8b596";
      base0C = "d9a088";
      base0D = "e595b0";
      base0E = "cc7a99";
      base0F = "8a5c68";
    };
    light = {
      # DawnRosé theme
      base00 = "f2e8ea";
      base01 = "e8dcdf";
      base02 = "d8c8cd";
      base03 = "9a838a";
      base04 = "6a555a";
      base05 = "3a2a2f";
      base06 = "2a1c20";
      base07 = "1c1215";
      base08 = "b8465f";
      base09 = "a05a3a";
      base0A = "8a6a30";
      base0B = "5a6b45";
      base0C = "3a6a90";
      base0D = "b0506d";
      base0E = "8a3555";
      base0F = "6a2838";
    };
  };
  polarity = "dark";
in
{
  stylix = {
    enable = true;
    inherit polarity;
    base16Scheme = palette.${polarity};

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      serif = {
        name = "Merriweather";
        package = pkgs.merriweather;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    targets = {
      console.enable = true;
      limine.enable = true;
      plymouth.enable = true;
    };
  };
}
