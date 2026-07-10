{
  config,
  lib,
  pkgs,
  ...
}:
let
  ws = map toString (lib.range 1 9);
  workspaceBinds = lib.concatMap (n: [
    "$mainMod, ${n}, workspace, ${n}"
    "$mainMod SHIFT, ${n}, movetoworkspace, ${n}"
  ]) ws;

  swayosd = lib.getExe' pkgs.swayosd "swayosd-client";
  focusedMonitor = "$(hyprctl activeworkspace -j | jq -r .monitor)";
in
lib.mkIf config.nerv.capabilities.desktop {
  wayland.windowManager.hyprland.settings = {
    # Keyboard bindings
    bind = [
      # Apps
      "$mainMod, Return, exec, $terminal"
      "$mainMod, D, exec, $menu"
      "$mainMod, Space, exec, $menu"
      "$mainMod, E, exec, $fileManager"
      "$mainMod SHIFT, E, exec, $fileManager2"
      "$mainMod, B, exec, $browser"
      "$mainMod SHIFT, B, exec, $browser2"
      "$mainMod, C, exec, $chat"
      "$mainMod SHIFT, C, exec, $chat2"
      "$mainMod, Z, exec, $editor"

      # Power and session
      "$mainMod, P, exec, $powerMenu"
      "$mainMod, L, exec, hyprlock-wrapper"
      "$mainMod SHIFT, M, exit"

      # Window management
      "$mainMod, Q, killactive"
      "$mainMod, V, togglefloating"
      "$mainMod, F, fullscreen"
      "$mainMod, P, pseudo"
      "$mainMod, J, layoutmsg, togglesplit"

      # Focus
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Workspaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
      "$mainMod, 0, workspace, 10"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Screenshots
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "SHIFT, Print, exec, mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"
      "$mainMod, Print, exec, grim -o \"${focusedMonitor}\" - | wl-copy"
      "$mainMod SHIFT, Print, exec, mkdir -p ~/Pictures/Screenshots && grim -o \"${focusedMonitor}\" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"

      # Clipboard history
      "$mainMod SHIFT, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

      # Passthrough
      "$mainMod, escape, submap, passthrough"
    ]
    ++ workspaceBinds;

    # Mouse-modifier bindings
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Repeating bindings
    binde = [
      ", XF86AudioRaiseVolume, exec, ${swayosd} --output-volume raise"
      ", XF86AudioLowerVolume, exec, ${swayosd} --output-volume lower"
    ];

    # Lock-safe bindings
    bindl = [
      ", XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, ${swayosd} --input-volume mute-toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
