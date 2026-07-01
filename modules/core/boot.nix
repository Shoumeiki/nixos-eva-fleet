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
    ];

    consoleLogLevel = 0;
    initrd.verbose = false;

    # Splash screen
    plymouth.enable = true;
  };
}
