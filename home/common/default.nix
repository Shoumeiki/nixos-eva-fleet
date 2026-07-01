{ pkgs, ... }:
{
  imports = [
    ./cli-tools.nix
    ./git.nix
    ./neovim.nix
    ./shell.nix
    ./stylix.nix
  ];

  # `use flake` in a project's `.envrc` activates the devShell on `cd`;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  home.packages = with pkgs; [
    # Nix tools
    nh
    nix-output-monitor
    nvd
    comma
  ];
}
