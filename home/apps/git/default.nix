# Identity comes from nerv.identity, set per-user (see home/ellen.nix) —
# guest leaves it at its null defaults and gets a generic, unsigned git.
{ config, lib, ... }:
{
  programs.git = {
    enable = true;

    signing = lib.mkIf (config.nerv.identity.signingKey != null) {
      key = config.nerv.identity.signingKey;
      format = "ssh";
      signByDefault = true;
    };

    settings = {
      user = lib.mkMerge [
        (lib.mkIf (config.nerv.identity.name != null) { name = config.nerv.identity.name; })
        (lib.mkIf (config.nerv.identity.email != null) { email = config.nerv.identity.email; })
      ];

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      # Better conflict markers / more readable diffs
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
    };
  };
}
