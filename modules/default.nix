# Aggregator imported by every host (see lib/default.nix's mkHost). Core
# modules are always active; roles/* gate themselves on nerv.capabilities.*.
_: {
  imports = [
    ./core/boot.nix
    ./core/nix-settings.nix
    ./core/nerv-options.nix
    ./core/secrets.nix
    ./core/theme.nix

    ./roles/desktop.nix
    ./roles/gaming.nix
    ./roles/virtualisation.nix
    ./roles/server.nix
    ./roles/nas.nix

    ./users
  ];
}
