{ theme, ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # Atuin owns Ctrl-R for history search.
    historyWidget.fish.command = "";
    colors = with theme.palette.hexH; {
      fg = base05;
      bg = base00;
      hl = base0D;
      "fg+" = base06;
      "bg+" = base02;
      "hl+" = base0D;
      info = base0C;
      prompt = base0E;
      pointer = base0D;
      marker = base0B;
      spinner = base0C;
      header = base03;
    };
  };
}
