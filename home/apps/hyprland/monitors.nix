# Monitor topology comes from nerv.hardware.monitors (set per-host at the
# NixOS level, see hosts/<hostname>/default.nix) instead of hardcoding
# output names here.
{ config, lib, ... }:
let
  monitors = config.nerv.hardware.monitors;

  toMonitorV2 = m: {
    inherit (m)
      output
      mode
      position
      scale
      ;
  };

  toWorkspaceLines =
    m:
    lib.imap0 (
      i: ws: "${toString ws}, monitor:${m.output}" + lib.optionalString (i == 0) ", default:true"
    ) m.workspaces;
in
lib.mkIf config.nerv.capabilities.desktop {
  wayland.windowManager.hyprland.settings = {
    monitorv2 = (map toMonitorV2 monitors) ++ [
      {
        # Catch-all for any other output that turns up.
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1.5;
      }
    ];
    workspace = lib.concatMap toWorkspaceLines monitors;
  };
}
