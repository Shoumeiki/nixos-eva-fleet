{ config, ... }:
{
  # Layout: ESP 512M | swap 32G (for hibernation) | btrfs root
  # Subvolumes: @, @home, @nix, @log, @snapshots
  disko.devices.disk.main = {
    type = "disk";
    device = config.nerv.disk.device;
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
            extraArgs = [
              "-n"
              "BOOT"
            ];
          };
        };
        swap = {
          size = "32G";
          content = {
            type = "swap";
            extraArgs = [
              "-L"
              "SWAP"
            ];
            discardPolicy = "both";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [
              "-L"
              "nixos"
              "-f"
            ];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@snapshots" = {
                mountpoint = "/var/snapshots";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
