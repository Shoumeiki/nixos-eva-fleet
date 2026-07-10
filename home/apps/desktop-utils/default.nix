# Miscellaneous desktop utility packages with no per-app config of their own
# (icon themes, bluetooth/network GUIs, etc.) — see home/apps/<name>/ for
# anything that has real home-manager configuration.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
lib.mkIf config.nerv.capabilities.desktop {
  home.packages = with pkgs; [
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    gpu-screen-recorder-gtk
    lm_sensors
    bluez-tools
    blueman # bluetooth GUI fallback, blueman-manager
    networkmanagerapplet # nm-connection-editor fallback GUI
    papirus-icon-theme
    pavucontrol
    easyeffects
    docker-compose
  ];
}
