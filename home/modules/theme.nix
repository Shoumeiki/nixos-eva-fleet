# Mirrors the NixOS-level nerv.theme.active fact (see
# modules/core/nerv-options.nix) into home-manager as a read-only default, via
# osConfig — same pattern as home/modules/capabilities.nix. No runtime
# switcher, no Stylix: this just resolves the hand-edited enum into the
# `theme` module argument, available to every home-manager file exactly like
# `config`/`lib`/`pkgs` are.
{
  config,
  lib,
  osConfig,
  ...
}:
let
  palettes = import ../lib/palettes.nix;
  tokens = import ../lib/tokens.nix;
  active = palettes.${config.nerv.theme.active};
in
{
  options.nerv.theme.active = lib.mkOption {
    type = lib.types.enum [
      "duskrose"
      "dawnrose"
    ];
    default = osConfig.nerv.theme.active or "duskrose";
    description = "Which hand-authored palette is active.";
  };

  config._module.args.theme = {
    palette = active // {
      hex = active.colors;
      hexH = builtins.mapAttrs (_: v: "#${v}") active.colors;
    };
    dark = active.appearance == "dark";
    inherit (tokens) fonts opacity cursor;
  };
}
