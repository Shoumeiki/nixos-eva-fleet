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

    stylix = {
      url = "github:nix-community/stylix";
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
      home-manager,
      treefmt-nix,
      git-hooks,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      moduleArgs = { inherit inputs self; };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

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
      nixosConfigurations = {
        unit-01 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = moduleArgs;
          modules = [
            ./hosts/unit-01
            inputs.sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = moduleArgs;

                # Back up any pre-existing plain file a module would otherwise
                # overwrite, instead of failing the activation
                backupFileExtension = "backup";
                overwriteBackup = true;
              };
            }
          ];
        };
      };

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
