# Mirrors nerv.hardware.* (see modules/core/nerv-options.nix) into
# home-manager. This is the single source of truth for monitor topology and
# GPU vendor, replacing the DP-1/HDMI-A-1/AMD literals that used to be
# duplicated across hyprland/monitors.nix, fastfetch.nix and cli-tools.nix.
{ lib, osConfig, ... }:
{
  options.nerv.hardware = {
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = osConfig.nerv.hardware.monitors or [ ];
      description = "Monitor topology for this host.";
    };

    gpu.vendor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "amd"
          "nvidia"
          "intel"
        ]
      );
      default = osConfig.nerv.hardware.gpu.vendor or null;
      description = "Primary GPU vendor for this host.";
    };
  };
}
