{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  services.udiskie.enable = true;
}
