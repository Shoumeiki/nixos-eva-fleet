# Game overlay tool — gated on the gaming capability, not just desktop.
# No bespoke theming — overlay text color is cosmetic-only.
{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.gaming {
  programs.mangohud.enable = true;
}
