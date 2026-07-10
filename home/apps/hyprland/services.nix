{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  services = {
    # GUI polkit agent
    hyprpolkitagent.enable = true;

    # Gnome-keyring user services
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
