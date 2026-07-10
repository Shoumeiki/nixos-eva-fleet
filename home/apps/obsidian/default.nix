# No bespoke theming — Obsidian has its own in-app theme picker.
{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  programs.obsidian.enable = true;
}
