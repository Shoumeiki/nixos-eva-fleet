# Mirrors the NixOS-level nerv.capabilities.* facts (see
# modules/core/nerv-options.nix) into home-manager as read-only defaults, via
# osConfig — home-manager here always runs as a NixOS submodule, so osConfig
# is the fully evaluated host config. App modules gate on these, not on
# osConfig directly, so they stay usable if home-manager is ever run
# standalone (defaults just fall back to false).
{ lib, osConfig, ... }:
{
  options.nerv.capabilities = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.nerv.capabilities.desktop or false;
      description = "Whether this host has a graphical (Hyprland) session.";
    };
    gaming = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.nerv.capabilities.gaming or false;
      description = "Whether this host/user gets gaming apps.";
    };
    creative = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.nerv.capabilities.creative or false;
      description = "Whether this host/user gets creative apps.";
    };
  };
}
