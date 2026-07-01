# Eva Fleet

Personal NixOS + home-manager flake for managing my machines. Work in progress.

## Structure

```
.
├── flake.nix
├── hosts/             # Per-machine system config
│   └── unit-01/
├── home/              # Per-user home-manager config
│   ├── ellen.nix
│   ├── common/
│   └── desktop/
│       └── hyprland/
├── modules/           # Reusable modules imported by hosts/home
│   ├── core/
│   └── desktop/
├── secrets/           # sops-encrypted secrets — safe to commit
├── .sops.yaml
├── docs/
├── justfile
└── treefmt.nix
```

- **`hosts/<hostname>/`** — system-wide config for a specific machine.
- **`home/<user>/`** — user/session config managed by home-manager.
- **`modules/nixos/`** / **`modules/home/`** — shared, reusable options imported where needed rather than duplicated.

## Usage

Common tasks are wrapped in the `justfile`:

```sh
just switch   # format, check, then apply the flake to the running system
just boot     # apply on next boot
just test     # build and activate without adding to bootloader
just dry      # show changes without applying
just build    # build the top-level system closure
just check    # nix flake check + statix + deadnix
just fmt      # format the tree
just update   # update flake inputs and switch
just gc       # garbage collect old generations
just diff     # diff booted vs current generation
```

Run `just` with no arguments to list all available targets.

## Secrets

Managed with [sops-nix](https://github.com/Mic92/sops-nix). No plaintext
secrets are stored in this repo — `secrets/secrets.yaml` holds only
sops-encrypted values, decryptable by an admin's personal age key or a
host's own SSH host key (no manual per-host key file to manage). See
[`docs/secrets.md`](docs/secrets.md) for setup, editing, and onboarding new
hosts.

## Status

Actively being restructured — hosts and home profiles are added incrementally as machines are brought under management.
