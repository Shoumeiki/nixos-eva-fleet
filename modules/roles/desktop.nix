# Everything needed for a graphical Hyprland session. Merged from the old
# modules/desktop/session.nix + apps.nix — both were unconditionally part of
# "having a desktop" with no independent value in staying split.
{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  programs = {
    hyprland.enable = true;
    # Needed for GTK theming on Hyprland
    dconf.enable = true;
    gpu-screen-recorder.enable = true;
  };

  services = {
    # Display manager: greetd + tuigreet
    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
    };

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  # Privilege escalation prompts for GUI apps
  security.polkit.enable = true;

  # Portal backends
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
