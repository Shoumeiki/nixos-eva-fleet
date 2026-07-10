{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko

    # Host-specific bits
    ./hardware.nix
    ./disko.nix
  ];

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  console.keyMap = "us";

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # Allow SSH access
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Disko target stable by-id path
  nerv.disk.device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_2349457CF10F";

  # Single source of truth for monitor topology and GPU vendor — consumed by
  # home-manager's hyprland/dms/fastfetch/nvtop modules via osConfig.
  nerv.hardware = {
    gpu.vendor = "amd";
    monitors = [
      {
        output = "DP-1";
        mode = "3840x2160@144";
        position = "0x0";
        scale = 1.25;
        primary = true;
        workspaces = [
          1
          2
          3
          4
          5
        ];
      }
      {
        output = "HDMI-A-1";
        mode = "3840x2560@50";
        position = "auto-right";
        scale = 1.6;
        primary = false;
        workspaces = [
          6
          7
          8
          9
        ];
      }
      {
        output = "HEADLESS-2";
        mode = "1920x1080@60";
        position = "auto-left";
        scale = 1.0;
        primary = false;
        workspaces = [ 10 ];
      }
    ];
  };

  system.stateVersion = "26.05";
}
