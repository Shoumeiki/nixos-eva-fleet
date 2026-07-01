{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko

    # Host-specific bits
    ./hardware.nix
    ./disko.nix

    # Core system modules
    ../../modules/core/boot.nix
    ../../modules/core/nix-settings.nix
    ../../modules/core/nerv-options.nix
    ../../modules/core/secrets.nix
    ../../modules/core/stylix.nix

    # Desktop modules
    ../../modules/desktop/session.nix
    ../../modules/desktop/apps.nix
    ../../modules/desktop/gaming.nix
    ../../modules/desktop/virtualisation.nix
  ];

  home-manager.users.ellen = import ../../home/ellen.nix;

  # Decrypt before user creation, since the hash feeds hashedPasswordFile below
  sops.secrets.ellen-password-hash.neededForUsers = true;

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  console.keyMap = "us";

  networking = {
    hostName = "unit-01";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # Allow SSH access
      allowedTCPPorts = [ 22 ];
    };
  };

  programs.fish.enable = true;
  users.users.ellen = {
    isNormalUser = true;
    description = "administrator";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
    hashedPasswordFile = config.sops.secrets.ellen-password-hash.path;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Disko target stable by-id path
  nerv.disk.device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_2349457CF10F";

  system.stateVersion = "26.05";
}
