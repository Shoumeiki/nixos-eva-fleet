# No bespoke theming — Discord client CSS injection isn't worth maintaining
# for a personal fleet; revisit with a custom CSS if wanted later.
{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  programs.vesktop.enable = true;
}
