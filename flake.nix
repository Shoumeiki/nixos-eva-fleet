{
  description = "NixOS + home-manager flake for Eva fleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      git-hooks,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      fleetLib = import ./lib { inherit inputs self; };

      # The fleet's host registry: hostname -> { capabilities, users, system }.
      # `users` defaults to [ "ellen" ]; add "guest" only on desktop-type hosts.
      hosts = {
        unit-01 = {
          capabilities = [
            "desktop"
            "gaming"
            "virtualisation"
            "creative"
          ];
          users = [
            "ellen"
            "guest"
          ];
        };

        # Headless Docker-services host — eval-proof stub, no real hardware
        # yet (see hosts/server-01/hardware.nix). `users` defaults to
        # [ "ellen" ]: no guest account on a headless host.
        server-01 = {
          capabilities = [ "server" ];
        };
      };

      preCommitCheck = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs fleetLib.mkHost hosts;

      # `nix fmt` > treefmt wrapper
      formatter.${system} = treefmtEval.config.build.wrapper;

      # `nix flake check` runs these
      checks.${system} = {
        formatting = treefmtEval.config.build.check self;
        pre-commit = preCommitCheck;
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        packages = [
          treefmtEval.config.build.wrapper
          pkgs.nh
          pkgs.nix-output-monitor
          pkgs.nvd
          pkgs.just
          pkgs.statix
          pkgs.deadnix
        ];
      };
    };
}
