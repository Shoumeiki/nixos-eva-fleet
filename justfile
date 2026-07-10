# Run `just` to see all targets

set shell := ["bash", "-cu"]

export NH_FLAKE := justfile_directory()

# Target host for nh commands (override: just host=server-01 <recipe>)
host := `hostname`

# Target user for home-manager commands (override: just user=guest <recipe>)
user := `whoami`

# Show available targets
default:
    @just --list

# List every host in the fleet registry
hosts:
    nix eval --json .#nixosConfigurations --apply builtins.attrNames

# Apply the current flake to the running system
switch: fmt check
    nh os switch --hostname {{ host }}

# Apply only the home-manager profile, skipping a full system rebuild
home:
    nix build .#nixosConfigurations.{{ host }}.config.home-manager.users.{{ user }}.home.activationPackage --no-link --print-out-paths | xargs -I{} sh -c '{}/activate'

# Apply to next boot
boot:
    nh os boot --hostname {{ host }}

# Build and activate without adding to bootloader
test:
    nh os test --hostname {{ host }}

# Show changes without applying
dry:
    nh os switch --hostname {{ host }} --dry

# Validate flake with all linters
check:
    nix flake check
    nix develop -c statix check .
    nix develop -c deadnix --fail .

# Build top-level system without activation
build:
    nix build .#nixosConfigurations.{{ host }}.config.system.build.toplevel

# Format the tree
fmt:
    nix fmt

# Update flake inuts and switch
update:
    nh os switch --hostname {{ host }} --update

# Garbace collection
gc:
    nh clean all --keep 5 --keep-since 7d

# Show the diff between current and booted generations
diff:
    nvd diff /run/booted-system /run/current-system
