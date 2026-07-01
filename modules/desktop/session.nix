{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  # Display manager: greetd + tuigreet
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
  };

  services.gnome.gnome-keyring.enable = true;
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

  # Needed for GTK theming on Hyprland
  programs.dconf.enable = true;
}
