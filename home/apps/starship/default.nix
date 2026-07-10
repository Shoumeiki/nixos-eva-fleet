# No bespoke theming — starship's default prompt uses named ANSI colors
# that kitty's palette already themes.
_: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
