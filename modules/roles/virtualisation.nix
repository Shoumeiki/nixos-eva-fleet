# Desktop-oriented virtualisation: full VM management (libvirtd/virt-manager)
# alongside Docker. For a headless Docker-only host, see roles/server.nix.
{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.nerv.capabilities.virtualisation {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  services.spice-vdagentd.enable = true;
}
