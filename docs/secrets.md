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

1. Add the host under `hosts/<hostname>/`, importing `modules/core/secrets.nix`
   (already default for all hosts).
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
