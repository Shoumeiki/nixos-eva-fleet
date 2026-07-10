# Extracted out of cli-tools so the AMD-specific package only installs on
# hosts that actually report an AMD GPU (see nerv.hardware.gpu.vendor).
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.nerv.hardware.gpu.vendor == "amd") {
  home.packages = [ pkgs.nvtopPackages.amd ];
}
