{ theme, ... }:
let
  c = theme.palette.colors;
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting

      set -g fish_color_normal      ${c.base05}
      set -g fish_color_command     ${c.base0D}
      set -g fish_color_keyword     ${c.base0E}
      set -g fish_color_quote       ${c.base0B}
      set -g fish_color_redirection ${c.base0C}
      set -g fish_color_end         ${c.base0C}
      set -g fish_color_error       ${c.base08}
      set -g fish_color_param       ${c.base05}
      set -g fish_color_comment     ${c.base03}
      set -g fish_color_operator    ${c.base09}
      set -g fish_color_autosuggestion ${c.base03}
      set -g fish_color_selection --background=${c.base02}
      set -g fish_pager_color_progress ${c.base03}
      set -g fish_pager_color_prefix ${c.base0D}
      set -g fish_pager_color_completion ${c.base05}
      set -g fish_pager_color_description ${c.base03}
    '';
    shellAbbrs = {
      # Nix workflow
      rebuild = "nh os switch";
      rebuild-boot = "nh os boot";
      rebuild-test = "nh os test";
      dry = "nh os switch --dry";
      update = "nh os switch --update";
      gen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      gen-diff = "nvd diff /run/booted-system /run/current-system";
      clean = "nh clean all --keep 5 --keep-since 7d";
      search = "nh search";
      repl = "nix repl --expr 'import <nixpkgs> {}'";

      # Tools and navigation
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --git --group-directories-first";
      la = "eza -la --icons --git --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat --paging=never";
      find = "fd";
      grep = "rg";
      du = "dust";
      df = "duf";
      ps = "procs";
      top = "btop";
      mkdir = "mkdir -pv";
      rm = "rm -rfv";
      c = "clear";
      cp = "cp -iv";
      mv = "mv -iv";

      # Git
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gca = "git commit --amend";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      gco = "git checkout";
      gsw = "git switch";

      # Utility and fun
      weather = "curl wttr.in/Melbourne";
      myip = "curl ifconfig.me";
    };
  };
}
