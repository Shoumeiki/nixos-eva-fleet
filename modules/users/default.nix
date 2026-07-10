{ lib, hostSpec, ... }:
let
  homeProfiles = {
    ellen = ../../home/users/ellen.nix;
    guest = ../../home/users/guest.nix;
  };
  present = builtins.filter (u: homeProfiles ? ${u}) hostSpec.users;
in
{
  imports = [
    ./ellen.nix
    ./guest.nix
  ];

  # Attachment point to home-manager.
  home-manager.users = lib.genAttrs present (u: import homeProfiles.${u});
}
