{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  services.swayosd.enable = true;
}
