{ lib, ... }:
{
  # `nerv.*` is this repo's own option namespace, not an upstream nixpkgs option
  options.nerv.disk.device = lib.mkOption {
    type = lib.types.str;
    description = "Stable by-id path to the target disk for disko";
  };
}
