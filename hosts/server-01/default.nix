# Headless Docker-services host — placeholder until real hardware is
# installed (see hardware.nix/disko.nix). No desktop, no guest account:
# proves the capability/user system composes correctly for a non-desktop
# host with zero edits to shared modules.
{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
  ];

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Placeholder — replace once real hardware is decided.
  nerv.disk.device = "/dev/disk/by-id/REPLACE-ME";

  system.stateVersion = "26.05";
}
