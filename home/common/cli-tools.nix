{ pkgs, ... }:
{
  # Tools with home-manager modules
  programs = {
    eza.enable = true;
    bat.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    jq.enable = true;
    bottom.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    tldr
    dust
    duf
    procs
    yq
    curl
    nvtopPackages.amd
  ];
}
