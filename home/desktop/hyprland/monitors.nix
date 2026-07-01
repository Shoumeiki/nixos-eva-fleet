_: {
  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
      {
        output = "DP-1";
        mode = "3840x2160@144";
        position = "0x0";
        scale = 1.25;
      }
      {
        output = "HDMI-A-1";
        mode = "3840x2560@50";
        position = "auto-right";
        scale = 1.6;
      }
      {
        output = "HEADLESS-2";
        mode = "1920x1080@60";
        position = "auto-left";
        scale = 1.0;
      }
      {
        # Catch-all for any other output that turns up.
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1.5;
      }
    ];
    workspace = [
      "1, monitor:DP-1, default:true"
      "2, monitor:DP-1"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
      "6, monitor:HDMI-A-1, default:true"
      "7, monitor:HDMI-A-1"
      "8, monitor:HDMI-A-1"
      "9, monitor:HDMI-A-1"
      "10, monitor:HEADLESS-2, default:true"
    ];
  };
}
