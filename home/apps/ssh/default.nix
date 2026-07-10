_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      AddKeysToAgent = "yes";

      ControlMaster = "auto";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "10m";

      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;

      HashKnownHosts = "yes";
    };
  };

  services.ssh-agent.enable = true;

  # Stop gnome-keyring hijacking SSH_AUTH_SOCK from services.ssh-agent above.
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
