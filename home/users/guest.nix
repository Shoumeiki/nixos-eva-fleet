# Limited guest profile — a browser and a terminal, none of ellen's personal
# dotfile customizations (no git identity, no atuin sync, no personal
# neovim/shell config). Only ever wired on desktop-type hosts (see the
# `users` list in each host's flake registry entry).
_: {
  imports = [
    ../modules
    ../apps/kitty
    ../apps/zen-browser
    ../apps/fish
  ];

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
