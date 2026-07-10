# Per-user personal data (git identity, signing key). Set in each user's
# composition root (e.g. home/ellen.nix) rather than hardcoded inside a
# shared app module — guest leaves these at their null defaults, so
# home/apps/git enables git generically with no identity/signing.
{ lib, ... }:
{
  options.nerv.identity = {
    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    signingKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
}
