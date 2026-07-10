# Owner/administrator account — present on every host.
{
  lib,
  pkgs,
  config,
  hostSpec,
  ...
}:
lib.mkIf (builtins.elem "ellen" hostSpec.users) {
  programs.fish.enable = true;

  # Decrypt before user creation, since the hash feeds hashedPasswordFile below
  sops.secrets.ellen-password-hash.neededForUsers = true;

  users.users.ellen = {
    isNormalUser = true;
    description = "administrator";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ]
    ++ lib.optionals config.nerv.capabilities.virtualisation [
      "docker"
      "libvirtd"
    ];
    hashedPasswordFile = config.sops.secrets.ellen-password-hash.path;
  };
}
