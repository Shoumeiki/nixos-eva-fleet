_: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  programs = {
    nix-index.enable = true;
    nix-ld.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    # Required dependency for electron apps
    # Version-pinned — bump this string whenever nixpkgs ships a newer pnpm,
    # or the build starts failing again on the next update
    permittedInsecurePackages = [ "pnpm-10.29.2" ];
  };
}
