{ lib, ... }:
let
  allCapabilities = import ../../lib/capabilities.nix;
in
{
  # `nerv.*` is this repo's own option namespace, not an upstream nixpkgs option
  options.nerv = {
    disk.device = lib.mkOption {
      type = lib.types.str;
      description = "Stable by-id path to the target disk for disko";
    };

    # One boolean per entry in lib/capabilities.nix. Set per-host from the
    # flake's host registry (see lib/default.nix); modules/roles/*.nix gate
    # their bodies on these, and home-manager mirrors them read-only via
    # osConfig.nerv.capabilities.*.
    capabilities = lib.genAttrs allCapabilities (
      name: lib.mkEnableOption "the ${name} capability for this host"
    );

    # Single hand-edited source of truth for which palette is live — mirrored
    # read-only into home-manager via osConfig (home/modules/theme.nix), and
    # read directly here for NixOS-level theming (modules/core/theme.nix).
    theme.active = lib.mkOption {
      type = lib.types.enum [
        "duskrose"
        "dawnrose"
      ];
      default = "duskrose";
      description = "Which hand-authored palette is active fleet-wide.";
    };

    hardware = {
      # Single source of truth for monitor topology — consumed by
      # home-manager's hyprland/dms/fastfetch modules instead of each
      # hardcoding output names independently.
      monitors = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              output = lib.mkOption {
                type = lib.types.str;
                description = ''Output name as reported by Wayland/Hyprland (e.g. "DP-1").'';
              };
              mode = lib.mkOption {
                type = lib.types.str;
                description = ''Resolution and refresh rate, e.g. "3840x2160@144".'';
              };
              position = lib.mkOption {
                type = lib.types.str;
                default = "auto";
              };
              scale = lib.mkOption {
                type = lib.types.float;
                default = 1.0;
              };
              primary = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              workspaces = lib.mkOption {
                type = lib.types.listOf lib.types.int;
                default = [ ];
              };
            };
          }
        );
        default = [ ];
        description = "Monitor topology for this host, consumed by home-manager desktop apps.";
      };

      gpu.vendor = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "amd"
            "nvidia"
            "intel"
          ]
        );
        default = null;
        description = "Primary GPU vendor, used to gate vendor-specific tooling.";
      };
    };
  };
}
