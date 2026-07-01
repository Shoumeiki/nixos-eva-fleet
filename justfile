# Run `just` to see all targets

set shell := ["bash", "-cu"]

export NH_FLAKE := justfile_directory()

# Target host for nh commands
host := "unit-01"

# Show available targets
default:
    @just --list

# Apply the current flake to the running system
switch: fmt check
    nh os switch --hostname {{host}}

# Apply to next boot
boot:
    nh os boot --hostname {{host}}

# Build and activate without adding to bootloader
test:
    nh os test --hostname {{host}}

# Show changes without applying
dry:
    nh os switch --hostname {{host}} --dry

# Validate flake with all linters
check:
    nix flake check
    nix develop -c statix check .
    nix develop -c deadnix --fail .

# Build top-level system without activation
build:
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

# Format the tree
fmt:
    nix fmt

# Update flake inuts and switch
update:
    nh os switch --hostname {{host}} --update

# Garbace collection
gc:
    nh clean all --keep 5 --keep-since 7d

# Show the diff between current and booted generations
diff:
    nvd diff /run/booted-system /run/current-system
