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

    # DankSearch — file indexing/search backing DMS's spotlight results.
    # dsearch.service starts on default.target, independent of any graphical
    # session, since indexing doesn't need Wayland.
    dsearch.enable = true;
  };

  services = {
    # Display manager: greetd + tuigreet
    greetd = {
      enable = true;
      # tuigreet is a TUI greeter — avoid systemd boot messages interrupting it.
      useTextGreeter = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
    };

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    # DMS reads these via D-Bus for user avatar/session info and CPU power
    # profile control; without them it just logs "not available" and skips
    # the related UI.
    accounts-daemon.enable = true;
    power-profiles-daemon.enable = true;

    # cups-pk-helper is pulled in automatically since security.polkit.enable
    # is set below.
    printing.enable = true;
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
