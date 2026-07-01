{ pkgs, ... }:
{
  boot = {
    loader = {
      limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;

    # Resume from swap partition
    resumeDevice = "/dev/disk/by-label/swap";

    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
      "video=HDMI-A-1:d"
    ];

    consoleLogLevel = 0;
    initrd.verbose = false;

    # Splash screen
    plymouth.enable = true;
  };

  systemd.services.reenable-hdmi = {
    description = "Re-enable HDMI-A-1 output after Plymouth boot splash";
    after = [ "plymouth-quit.service" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for f in /sys/class/drm/card*-HDMI-A-1/status; do
        [ -e "$f" ] && echo detect > "$f"
      done
    '';
  };
}
