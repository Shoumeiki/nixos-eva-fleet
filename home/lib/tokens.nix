# Palette-independent shared values, replacing Stylix's fonts/opacity/cursor
# options. Plain data — package names are resolved against `pkgs` at each
# call site, not baked in here.
{
  fonts = {
    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = "nerd-fonts.jetbrains-mono";
    };
    sansSerif = {
      name = "Inter";
      package = "inter";
    };
    serif = {
      name = "Merriweather";
      package = "merriweather";
    };
    emoji = {
      name = "Noto Color Emoji";
      package = "noto-fonts-color-emoji";
    };
    sizes = {
      terminal = 12;
      desktop = 12;
      applications = 12;
      popups = 10;
    };
  };

  # Single source of truth for background translucency — kitty, waybar,
  # rofi and hyprlock all read these directly (none of them support this via
  # their native theming, which is why they were already hand-rolled).
  opacity = {
    terminal = 0.85;
    applications = 0.85;
    popups = 0.85;
    desktop = 0.85;
  };

  cursor = {
    name = "Bibata-Modern-Classic";
    package = "bibata-cursors";
    size = 24;
  };
}
