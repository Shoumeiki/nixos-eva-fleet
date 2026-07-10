{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.dankcalendar.homeModules.dank-calendar ];

  config = lib.mkIf config.nerv.capabilities.desktop {
    programs.dank-calendar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
    };
  };
}
