{ config, lib, ... }:
lib.mkIf config.nerv.capabilities.desktop {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "no_anim true, match:namespace ^(dms:.*)$"
    ];
    windowrule = [
      # Skip Hyprland's render delay for games (reduces input latency)
      "match:class ^(steam_app_)(.*)$, immediate true"

      "match:title ^(Minecraft.*)$, float true, size 70% 70%, center true, immediate true, idle_inhibit always, no_blur true, no_shadow true, rounding 0"

      "match:class ^(org.quickshell)$, float true"
      "match:class ^(pavucontrol)$, float true"
      "match:class ^(blueman-manager)$, float true"
      "match:class ^(nm-connection-editor)$, float true"
      "match:class ^(\\.?(file-roller|nautilus))$, float true"
      "match:title ^(Picture-in-Picture)$, float true, pin true"

      # Don't lock/sleep while anything is fullscreen (video, games)
      "match:class .*, idle_inhibit fullscreen"
    ];
  };
}
