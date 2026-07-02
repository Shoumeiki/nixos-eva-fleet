{ pkgs, ... }:
{
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

  security.pki.certificateFiles = [
    ./certs/caddy-root.crt
  ];
  # Run to insert into Chromium database
  # `certutil -d sql:$HOME/.pki/nssdb -A -n "Caddy Local Root" -t "TC,C,C" -i ${./certs/caddy-root.crt}`
  environment.systemPackages = [ pkgs.nssTools ];

  nixpkgs.config = {
    allowUnfree = true;
    # Required dependency for electron apps
    # Version-pinned — bump this string whenever nixpkgs ships a newer pnpm,
    # or the build starts failing again on the next update
    permittedInsecurePackages = [ "pnpm-10.29.2" ];
  };
}
