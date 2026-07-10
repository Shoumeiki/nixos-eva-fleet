{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.nerv.capabilities.gaming {
  assertions = [
    {
      assertion = config.nerv.capabilities.desktop;
      message = "nerv.capabilities.gaming requires nerv.capabilities.desktop (Steam/gamescope need a graphical session).";
    }
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  programs.gamemode.enable = true;
}
