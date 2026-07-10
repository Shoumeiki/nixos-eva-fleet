# Placeholder — replace with the real hardware-scan output once server-01
# is actually installed. Generic enough to evaluate/build in the meantime.
_: {
  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "xhci_pci"
    "usbhid"
    "sd_mod"
    "sr_mod"
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
  ];

  hardware.enableRedistributableFirmware = true;

  services.fstrim.enable = true;
}
