_: {
  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Shoumeiki";
        email = "186657365+Shoumeiki@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      # Better conflict markers / more readable diffs
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
    };
  };

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
