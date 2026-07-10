_: {
  imports = [
    ../modules
    ../apps
    ../bundles/creative.nix
    ../bundles/gaming.nix
  ];

  nerv.identity = {
    name = "Shoumeiki";
    email = "186657365+Shoumeiki@users.noreply.github.com";
    signingKey = "~/.ssh/id_ed25519.pub";
  };

  home = {
    username = "ellen";
    homeDirectory = "/home/ellen";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
