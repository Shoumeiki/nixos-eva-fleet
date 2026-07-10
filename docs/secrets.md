# Secrets with sops-nix

Hosts decrypt secrets using their own SSH host key
(`/etc/ssh/ssh_host_ed25519_key`) — no manual key file to copy onto new
machines. You only manage keys in two places: your personal admin key (for
editing secrets) and `.sops.yaml` (which recipients can decrypt).

## One-time: your personal admin key

```console
$ nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
```

Back this up somewhere durable (password manager, offline copy) — if it's
lost, secrets can no longer be edited until a host re-encrypts them for a
new admin key. Get the public key with:

```console
$ nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

Paste that into `.sops.yaml` under `&admin_ellen`.

### If the admin key is lost

Recover from a host that can already decrypt the secrets:

1. Generate a new admin key (command above) and add its public key to
   `.sops.yaml` under `&admin_ellen`.
2. From a host with access (or via SSH to one), decrypt and re-encrypt so
   the new key is a valid recipient:

   ```console
   $ nix run nixpkgs#sops -- updatekeys secrets/secrets.yaml
   ```

If every host is also gone, the secrets are unrecoverable — re-create them
from scratch.

## Adding a new host

1. Add the host under `hosts/<hostname>/` and register it in `flake.nix`'s
   `hosts` registry (`modules/core/secrets.nix` is already part of every
   host via the shared `modules/` aggregator — nothing to import manually).
2. Install the host once so `/etc/ssh/ssh_host_ed25519_key.pub` exists.
3. Get its age public key:

   ```console
   $ nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub
   ```

4. Add it to `.sops.yaml` as `&host_<hostname>` and include it in the
   relevant `creation_rules` key group.
5. Re-encrypt so the new host can read the secrets:

   ```console
   $ nix run nixpkgs#sops -- updatekeys secrets/secrets.yaml
   ```

6. Rebuild — secrets decrypt automatically at activation.

### Host-scoped secrets

Most secrets (e.g. `ellen-password-hash`) live in the single shared
`secrets/secrets.yaml`, readable by every host's key. A secret that only one
host should ever decrypt (a service token for the future home-server, say)
goes in its own `secrets/hosts/<hostname>.yaml` instead:

1. Add a `creation_rules` entry scoped to `secrets/hosts/<hostname>\.yaml$`,
   with only the admin key and that host's key.
2. Declare the secret at its point of use with an explicit
   `sopsFile = ../../secrets/hosts/<hostname>.yaml;`.

This keeps a compromised or rotated host-specific secret from needing every
other host's key touched.

## Editing secrets

```console
$ nix run nixpkgs#sops -- secrets/secrets.yaml
```

Opens `$EDITOR` with the decrypted contents; on save it re-encrypts for the
recipients listed in `.sops.yaml`.

## Using a secret in a host/module

```nix
{
  sops.secrets.example-key = { };
}
```

The decrypted value is available at runtime at `/run/secrets/example-key`.
Reference that path from services (e.g.
`PasswordFile = config.sops.secrets.example-key.path;`).
