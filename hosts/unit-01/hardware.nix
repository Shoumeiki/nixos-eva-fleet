{ lib, ... }:
{
  boot.initrd.availableKernelModules = [
    # VM
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
    # Bare metal
    "ahci"
    "nvme"
    "xhci_pci"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings.General.Experimental = true;
    };
  };
  powerManagement.cpuFreqGovernor = "performance";

  # Audio
  security.rtkit.enable = true;

  services = {
    fwupd.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    blueman.enable = true;

    # SSD
    fstrim.enable = true;
    smartd = {
      enable = true;
      autodetect = true;
      notifications.wall.enable = true;
    };
  };

  # Fallback to the same generation under systemd-boot if Limine fails
  specialisation.systemd-boot-fallback.configuration = {
    boot.loader = {
      limine.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce true;
    };
  };
}
