# Limited guest account — only ever attached on desktop-type hosts (see the
# `users` list in each host's flake registry entry); never present on
# headless servers/NAS.
{
  lib,
  pkgs,
  hostSpec,
  ...
}:
lib.mkIf (builtins.elem "guest" hostSpec.users) {
  users.users.guest = {
    isNormalUser = true;
    description = "guest";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "video"
      "audio"
    ];
    # Low-privilege shared account by design — not a secret. Change locally
    # with `passwd guest` if a different password is wanted.
    initialPassword = "guest";
  };
}
