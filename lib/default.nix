{ inputs, self }:
let
  lib = inputs.nixpkgs.lib;
  allCapabilities = import ./capabilities.nix;
in
{
  inherit allCapabilities;

  # Builds one nixosConfigurations.<hostname> entry from a registry spec
  # ({ capabilities ? [ ], users ? [ "ellen" ], system ? "x86_64-linux" }).
  # Capabilities gate modules/roles/*.nix; users gates modules/users/*.nix
  # and which home-manager profiles get attached.
  mkHost =
    hostname: hostSpec:
    let
      spec = {
        system = "x86_64-linux";
        capabilities = [ ];
        users = [ "ellen" ];
      }
      // hostSpec
      // {
        inherit hostname;
      };
    in
    lib.nixosSystem {
      inherit (spec) system;
      specialArgs = {
        inherit inputs self;
        hostSpec = spec;
      };
      modules = [
        ../modules
        ../hosts/${hostname}
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        {
          networking.hostName = hostname;
          nerv.capabilities = lib.genAttrs allCapabilities (c: builtins.elem c spec.capabilities);

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs self;
              hostSpec = spec;
            };

            # Back up any pre-existing plain file a module would otherwise
            # overwrite, instead of failing the activation
            backupFileExtension = "backup";
            overwriteBackup = true;
          };
        }
      ];
    };
}
