_: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        padding = {
          top = 1;
          right = 2;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = "cyan";
          title = "magenta";
        };
      };

      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "magenta";
            at = "white";
            host = "magenta";
          };
        }
        {
          type = "custom";
          format = "[90m─────────────────────────────[0m";
        }

        {
          type = "os";
          key = "  OS";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "  Kernel";
          keyColor = "blue";
        }
        {
          type = "uptime";
          key = "  Uptime";
          keyColor = "blue";
        }
        {
          type = "packages";
          key = "  Packages";
          keyColor = "blue";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = "blue";
        }

        "break"
        {
          type = "custom";
          format = "[35m  Desktop[0m";
        }
        {
          type = "de";
          key = "  DE";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "magenta";
        }
        {
          type = "wmtheme";
          key = "  Theme";
          keyColor = "magenta";
        }
        {
          type = "terminal";
          key = "  Terminal";
          keyColor = "magenta";
        }
        {
          type = "terminalfont";
          key = "  Font";
          keyColor = "magenta";
        }

        "break"
        {
          type = "custom";
          format = "[32m  Hardware[0m";
        }
        {
          type = "cpu";
          key = "  CPU";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "  GPU";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "  Memory";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "  Disk";
          keyColor = "green";
        }
        {
          type = "battery";
          key = "  Battery";
          keyColor = "green";
        }

        "break"
        {
          type = "localip";
          key = "  Local IP";
          keyColor = "yellow";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
