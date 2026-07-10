# Theming here is build-time only (see home/modules/theme.nix) — waybar's
# own CSS, kitty's palette, hyprland, console/limine are all Nix-generated at
# build. There's no lightweight runtime-only toggle that would actually
# re-color any of that, so this automates the hand-edit + rebuild a human
# would otherwise do: flip nerv.theme.active's default in the checked-out
# repo, then `nh os switch`. Hardcoded repo path — this is a single-machine
# personal flake, not a portable tool.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  nervThemeToggle = pkgs.writeShellApplication {
    name = "nerv-theme-toggle";
    runtimeInputs = with pkgs; [
      gnugrep
      gnused
      nh
    ];
    text = ''
      REPO="$HOME/Projects/new"
      FILE="$REPO/modules/core/nerv-options.nix"

      current=$(grep -oP 'default = "\K(duskrose|dawnrose)(?=";)' "$FILE" | head -n1)

      if [ "''${1:-}" = "--status" ]; then
        # Font Awesome nerd-font glyphs: nf-fa-moon_o (f186) / nf-fa-sun_o (f185)
        if [ "$current" = duskrose ]; then
          printf '\n'
        else
          printf '\n'
        fi
        exit 0
      fi

      if [ "$current" = duskrose ]; then
        next=dawnrose
      else
        next=duskrose
      fi

      sed -i "0,/default = \"$current\";/s//default = \"$next\";/" "$FILE"

      echo "Switching theme: $current -> $next"
      nh os switch --hostname "$(hostname)" --flake "$REPO"

      # nh os switch activates home-manager via the NixOS-triggered
      # home-manager-<user>.service, which doesn't reliably reach this
      # session's systemd --user manager to restart waybar.service. Run the
      # same direct activation the justfile's `home` recipe uses instead —
      # inherits this interactive session's environment, so it actually
      # reloads waybar/kitty/dolphin configs.
      hmActivation=$(
        nix build \
          "$REPO#nixosConfigurations.$(hostname).config.home-manager.users.$(whoami).home.activationPackage" \
          --no-link --print-out-paths
      )
      "$hmActivation/activate"

      pkill -RTMIN+8 waybar || true
    '';
  };
in
lib.mkIf config.nerv.capabilities.desktop {
  home.packages = [ nervThemeToggle ];
}
