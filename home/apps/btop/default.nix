{ pkgs, theme, ... }:
let
  c = theme.palette.hexH;
  themeFile = pkgs.writeText "${theme.palette.name}.theme" ''
    theme[main_bg]="${c.base00}"
    theme[main_fg]="${c.base05}"
    theme[title]="${c.base06}"
    theme[hi_fg]="${c.base0D}"
    theme[selected_bg]="${c.base02}"
    theme[selected_fg]="${c.base0D}"
    theme[inactive_fg]="${c.base03}"
    theme[graph_text]="${c.base05}"
    theme[proc_misc]="${c.base0C}"
    theme[cpu_box]="${c.base0D}"
    theme[mem_box]="${c.base0B}"
    theme[net_box]="${c.base0E}"
    theme[proc_box]="${c.base09}"
    theme[div_line]="${c.base02}"
    theme[temp_start]="${c.base0B}"
    theme[temp_mid]="${c.base0A}"
    theme[temp_end]="${c.base08}"
    theme[cpu_start]="${c.base0B}"
    theme[cpu_mid]="${c.base0A}"
    theme[cpu_end]="${c.base08}"
    theme[free_start]="${c.base0B}"
    theme[free_mid]="${c.base0A}"
    theme[free_end]="${c.base08}"
    theme[cached_start]="${c.base0C}"
    theme[cached_mid]="${c.base0C}"
    theme[cached_end]="${c.base0C}"
    theme[available_start]="${c.base0D}"
    theme[available_mid]="${c.base0D}"
    theme[available_end]="${c.base0D}"
    theme[used_start]="${c.base08}"
    theme[used_mid]="${c.base08}"
    theme[used_end]="${c.base08}"
    theme[download_start]="${c.base0B}"
    theme[download_mid]="${c.base0A}"
    theme[download_end]="${c.base08}"
    theme[upload_start]="${c.base0B}"
    theme[upload_mid]="${c.base0A}"
    theme[upload_end]="${c.base08}"
  '';
in
{
  xdg.configFile."btop/themes/${theme.palette.name}.theme".source = themeFile;
  programs.btop = {
    enable = true;
    settings = {
      color_theme = theme.palette.name;
      theme_background = false;
    };
  };
}
