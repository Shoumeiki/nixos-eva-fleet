{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.dms.homeModules.dank-material-shell ];

  # Deliberately left at upstream defaults, including its own Material/
  # matugen theming — this is a stepping stone toward a fully custom
  # quickshell shell later, so it should carry no repo-specific config
  # to unwind.
  config = lib.mkIf config.nerv.capabilities.desktop {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
    };

    # DMS's own default monoFontFamily setting — installed so its default
    # resolves, not part of our theme tokens.
    home.packages = [ pkgs.fira-code ];
  };
}
