{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs = {
    mpv.enable = true;
    zathura.enable = true;
    ncmpcpp.enable = true;
    zed-editor = {
      enable = true;
      themes.duskrose = builtins.fromJSON (builtins.readFile ./zed-themes/duskrose.json);
      userSettings.theme = "Base16 DuskRose";
    };
    vesktop.enable = true;
    obsidian.enable = true;
    mangohud.enable = true;

    zen-browser = {
      enable = true;
      profiles.default = { };
    };

    ghostty = {
      enable = true;
      settings = {
        scrollback-limit = 10000000;
        confirm-close-surface = false;
        window-padding-x = 8;
        window-padding-y = 8;
      };
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    swayosd.enable = true;
    udiskie.enable = true;

    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      network.startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
      '';
    };

    mako = {
      enable = true;
      settings = {
        anchor = "top-right";
        default-timeout = 5000;
        ignore-timeout = false;
        max-history = 50;
        layer = "overlay";
        margin = 10;
        padding = 12;
      };
    };
  };

  home.packages = with pkgs; [
    # Browsers
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Communication
    signal-desktop

    # Creative
    krita
    audacity
    pinta

    # Notes and docs
    libreoffice-fresh

    # Media
    imv

    # Gaming
    heroic
    prismlauncher

    # Desktop Utilities
    gpu-screen-recorder-gtk
    lm_sensors
    bluez-tools
    blueman # waybar bluetooth on-click
    networkmanagerapplet # nm-connection-editor, waybar network on-click
    papirus-icon-theme
    pavucontrol
    easyeffects

    # Dev tools
    docker-compose

    # yazi
    ouch
    ffmpegthumbnailer
    poppler
    fd
    ripgrep
  ];
}
