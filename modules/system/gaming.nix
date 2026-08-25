{ pkgs, ... }:

let
  headlessToggle = pkgs.writeShellApplication {
    name = "headless-toggle";
    runtimeInputs = [ pkgs.jq pkgs.sway ];
    text = ''
      HEADLESS="HEADLESS-1"
      PHYSICAL_ACTIVE=$(swaymsg -t get_outputs | jq -r ".[] | select(.name != \"$HEADLESS\" and .active == true) | .name")
      if [ -n "$PHYSICAL_ACTIVE" ]; then
          swaymsg output "HEADLESS-1" enable
          for mon in $PHYSICAL_ACTIVE; do
              swaymsg output "$mon" disable
          done
          swaymsg workspace 99
      else
          swaymsg output "*" enable
          swaymsg output "HEADLESS-1" disable
          # pkill waybar
          # waybar &
          swaymsg workspace "99"
          # swaymsg move workspace to output '"LG Electronics LG ULTRAGEAR 407NTVS68263"'
      fi
    '';
  };
in
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  services.lact.enable = true;
  services.sunshine = {
    enable = true;
    openFirewall = true;
    settings = {
      back_button_timeout = 2000;
    };
    applications = {
      apps = [
        {
          name = "Steam";
          detached = [
            "${pkgs.gamescope}/bin/gamescope -e -H 1440 -W 2560 -r 144 -- ${pkgs.steam}/bin/steam -gamepadui"
          ];
          prep-cmd = [
            {
              do = "${headlessToggle}/bin/headless-toggle";
              undo = "${headlessToggle}/bin/headless-toggle";
            }
            {
              do = "steam -shutdown";
            }
          ];
        }
      ];
    };
  };
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
}
