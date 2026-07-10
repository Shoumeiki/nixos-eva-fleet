# Explicit aggregate of every app module (deliberately not builtins.readDir,
# so deadnix/statix can trace unused imports and users can cherry-pick
# individual apps instead of all-or-nothing). Capability-gated apps
# (creative/gaming-only) are reached via home/bundles/* instead, not here.
_: {
  imports = [
    ./cli-tools
    ./btop
    ./fzf
    ./bat
    ./nvtop
    ./git
    ./ssh
    ./neovim
    ./fish
    ./starship
    ./atuin
    ./direnv
    ./nix-tools
    ./fastfetch
    ./kitty
    ./hyprland
    ./mpv
    ./zathura
    ./ncmpcpp
    ./vesktop
    ./obsidian
    ./zen-browser
    ./yazi
    ./gtk
    ./qt
    ./udiskie
    ./mpd
    ./zed
    ./signal
    ./imv
    ./dolphin
    ./desktop-utils
    ./dms
  ];
}
