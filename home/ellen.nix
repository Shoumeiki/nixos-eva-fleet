_: {
  imports = [
    ./common
    ./desktop
  ];

  home = {
    username = "ellen";
    homeDirectory = "/home/ellen";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
