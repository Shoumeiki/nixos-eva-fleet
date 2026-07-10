{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  c = theme.palette.hexH;
  font = theme.fonts.sansSerif.name;
  fontSize = theme.fonts.sizes.applications * 2;

  # 2-digit hex alpha suffix from a 0.0-1.0 opacity value
  hexDigits = "0123456789abcdef";
  toHex1 = d: builtins.substring d 1 hexDigits;
  alphaHex =
    opacity:
    let
      n = builtins.floor (opacity * 255 + 0.5);
    in
    toHex1 (n / 16) + toHex1 (lib.mod n 16);
  a = alphaHex theme.opacity.popups;

  themeFile = pkgs.writeText "rofi-theme.rasi" ''
    * {
      background-color: transparent;
      text-color:       ${c.base05};
    }

    window {
      background-color: ${c.base00}${a};
      border:           2px solid;
      border-color:     ${c.base0D};
      border-radius:    18px;
      width:            640px;
      padding:          18px;
      location:         center;
      anchor:           center;
    }

    mainbox {
      background-color: transparent;
      children:         [ inputbar, listview ];
      spacing:          12px;
    }

    /* Search bar */
    inputbar {
      background-color: ${c.base01}${a};
      border-radius:    999px;
      padding:          10px 20px;
      children:         [ entry ];
    }

    entry {
      background-color:  transparent;
      text-color:        ${c.base05};
      placeholder:       "  Search…";
      placeholder-color: ${c.base03};
    }

    /* Results list */
    listview {
      background-color: transparent;
      lines:            8;
      columns:          1;
      fixed-height:     false;
      spacing:          4px;
    }

    element {
      background-color: transparent;
      border-radius:    10px;
      padding:          10px 16px;
      orientation:      horizontal;
      spacing:          12px;
    }

    element selected {
      background-color: ${c.base01}${a};
      text-color:       ${c.base0D};
    }

    element-icon {
      background-color: transparent;
      size:             1.5em;
      vertical-align:   0.5;
    }

    element-text {
      background-color: transparent;
      text-color:       inherit;
      vertical-align:   0.5;
      expand:           true;
    }

    /*Scrollbar */
    scrollbar {
      background-color: ${c.base01};
      handle-color:     ${c.base03};
      handle-width:     4px;
      border-radius:    2px;
      width:            4px;
      margin:           0 0 0 4px;
    }
  '';
in
lib.mkIf config.nerv.capabilities.desktop {
  programs.rofi = {
    enable = true;
    font = "${font} ${toString fontSize}";
    theme = "${themeFile}";

    extraConfig = {
      modi = "drun,run,filebrowser";
      show-icons = true;
      drun-display-format = "{name}";
      terminal = "${pkgs.kitty}/bin/kitty";
      kb-cancel = "Escape,Super+d";
      kb-row-up = "Up";
      kb-row-down = "Down";
      kb-accept-entry = "Return,KP_Enter";
      cycle = true;
      display-drun = "";
      display-run = "";
      display-filebrowser = "";
    };
  };
}
