# Headless Docker-services host baseline (e.g. the future home-server).
# Deliberately independent of roles/virtualisation.nix, which also brings in
# desktop-oriented VM management (libvirtd/virt-manager) that a headless
# Docker box doesn't need.
{ lib, config, ... }:
lib.mkIf config.nerv.capabilities.server {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };
}
