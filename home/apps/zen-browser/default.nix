# No bespoke theming — Zen has its own native theming; revisit with a static
# userChrome.css later if wanted.
{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.default ];

  config = lib.mkIf config.nerv.capabilities.desktop {
    programs.zen-browser = {
      enable = true;
      profiles.default = { };
    };
  };
}
