# Scaffold for a future NAS host — fill in storage/share services (ZFS,
# Samba/NFS) once real NAS hardware exists. Intentionally minimal for now.
{ lib, config, ... }:
lib.mkIf config.nerv.capabilities.nas { }
