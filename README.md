# Eva Fleet

Personal NixOS + home-manager flake for managing my machines. Work in progress.

## Structure

```
.
├── flake.nix          # inputs + host registry (hostname -> capabilities/users)
├── lib/               # mkHost factory, shared capability list
├── hosts/             # Per-machine system config
│   ├── unit-01/         # gaming/dev desktop
│   └── server-01/       # headless Docker host (hardware placeholder)
├── home/              # Home-manager config, organized per-app
│   ├── lib/             # palettes.nix (DuskRose/DawnRose), tokens.nix
│   ├── modules/         # capability/hardware/identity/theme option decls
│   ├── apps/             # one directory per app (config + theme colocated)
│   ├── bundles/          # capability-exclusive app groupings (creative, gaming)
│   └── users/            # composition roots: ellen.nix, guest.nix
├── modules/           # Reusable NixOS modules imported by every host
│   ├── core/            # always-on essentials (boot, secrets, nerv.* options, theming)
│   ├── roles/            # capability-gated (desktop, gaming, virtualisation, server, nas)
│   └── users/            # ellen/guest NixOS accounts, gated on the host's `users` list
├── secrets/           # sops-encrypted secrets — safe to commit
├── .sops.yaml
├── docs/
├── justfile
└── treefmt.nix
```

- **Hosts opt into capabilities**, not fixed import lists — a host's entry
  in `flake.nix`'s registry (`capabilities = [ "desktop" "gaming" ]; users =
  [ "ellen" "guest" ];`) decides which `modules/roles/*.nix` and NixOS
  accounts it gets.
- **`ellen`** (owner/admin) is on every host; **`guest`** (limited profile)
  only appears on desktop-type hosts.
- **Home-manager is per-app** (`home/apps/<name>/`) rather than per-bucket —
  each app's config and theme file live together. Apps gate themselves on
  the same capability flags, mirrored from the NixOS host via `osConfig`.
- **Theming is plain data**, not a framework — `home/lib/palettes.nix` holds
  the hand-authored DuskRose (dark) and DawnRose (light) palettes; no
  Stylix.

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
just hosts    # list every host in the fleet registry
```

`host`/`user` default to the current machine/user (override with
`just host=server-01 user=ellen <recipe>`). Run `just` with no arguments to
list all available targets.

## Secrets

Managed with [sops-nix](https://github.com/Mic92/sops-nix). No plaintext
secrets are stored in this repo — `secrets/secrets.yaml` holds only
sops-encrypted values, decryptable by an admin's personal age key or a
host's own SSH host key (no manual per-host key file to manage). See
[`docs/secrets.md`](docs/secrets.md) for setup, editing, and onboarding new
hosts.

## Status

The capability/user architecture is in place across two hosts: `unit-01`
(real gaming/dev desktop) and `server-01` (a headless Docker-host stub,
eval-proof only until real hardware is decided). A NAS host will follow the
same pattern once hardware exists — see `modules/roles/nas.nix`.
