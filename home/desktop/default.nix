_: {
  imports = [
    ./apps.nix
    ./rofi.nix
    ./stylix.nix
    ./waybar.nix

    # hyprland
    ./hyprland
  ];

  programs.fish.interactiveShellInit = ''
    if status is-interactive
      and not set -q FASTFETCH_SHOWN
        set -gx FASTFETCH_SHOWN 1
        fastfetch
    end
  '';
}
