{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  programs.ncmpcpp.enable = true;
}
