_: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = "set -g fish_greeting";
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

        # Hyprland
        monitors = "hyprctl monitors";
        clients = "hyprctl clients";
        reload-hypr = "hyprctl reload";

        # Utility and fun
        weather = "curl wttr.in/Melbourne";
        myip = "curl ifconfig.me";
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    # Shell history with sync
    atuin = {
      enable = true;
      enableFishIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        enter_accept = false;
        filter_mode_shell_up_key_down = "session";
        style = "compact";
      };
    };
  };
}
