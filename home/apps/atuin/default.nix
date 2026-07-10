# Shell history with sync — personal to a user, not installed for guest.
_: {
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      enter_accept = false;
      filter_mode_shell_up_key_down = "session";
      style = "compact";
    };
  };
}
