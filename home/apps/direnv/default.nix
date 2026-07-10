# `use flake` in a project's `.envrc` activates the devShell on `cd`
_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
