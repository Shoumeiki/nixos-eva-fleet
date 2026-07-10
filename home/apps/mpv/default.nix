# No bespoke theming — mpv's OSD is cosmetic-only, not worth a custom theme.
{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  programs.mpv.enable = true;
}
