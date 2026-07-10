# GTK theme + cursor, replacing Stylix's GTK target. adw-gtk3 is a real
# GTK3/4 theme; accent/window colors come from the palette via a small CSS
# override, theme/icon name and the color-scheme portal signal follow
# theme.dark so light palettes (DawnRose) aren't stuck looking dark.
{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  c = theme.palette.hexH;
  accentCss = ''
    @define-color accent_color ${c.base0D};
    @define-color accent_bg_color ${c.base0D};
    @define-color accent_fg_color ${c.base00};
    @define-color window_bg_color ${c.base00};
    @define-color window_fg_color ${c.base05};
    @define-color view_bg_color ${c.base01};
    @define-color view_fg_color ${c.base05};
  '';
  gtkThemeName = if theme.dark then "adw-gtk3-dark" else "adw-gtk3";
  iconThemeName = if theme.dark then "Papirus-Dark" else "Papirus";
in
lib.mkIf config.nerv.capabilities.desktop {
  gtk = {
    enable = true;
    theme = {
      name = gtkThemeName;
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = iconThemeName;
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = theme.cursor.name;
      package = pkgs.bibata-cursors;
      size = theme.cursor.size;
    };
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = theme.dark;
    gtk3.extraCss = accentCss;
    gtk4.extraCss = accentCss;
  };

  # The actual dark/light signal xdg-desktop-portal-gtk forwards to
  # portal-aware GTK4/libadwaita/Qt apps over org.freedesktop.appearance —
  # never set before, so apps always saw the gsettings default (light).
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = if theme.dark then "prefer-dark" else "default";
    gtk-theme = gtkThemeName;
    icon-theme = iconThemeName;
  };

  # Stylix also sets this unconditionally (not gated by a target); force ours
  # until Stylix is removed fleet-wide.
  home.pointerCursor = lib.mkForce {
    name = theme.cursor.name;
    package = pkgs.bibata-cursors;
    size = theme.cursor.size;
    gtk.enable = true;
  };
}
