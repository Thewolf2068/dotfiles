{ pkgs, ... }:
let
  headlessToggle = pkgs.writeShellApplication {
    name = "headless-toggle";
    runtimeInputs = [ pkgs.jq pkgs.sway ];
    text = ''
      HEADLESS="''${1:?Usage: headless-toggle <headless-output-name>}"

      HEADLESS_ACTIVE=$(swaymsg -t get_outputs | jq -r --arg h "$HEADLESS" '.[] | select(.name == $h) | .active')

      mapfile -t ALL_PHYSICAL < <(swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("HEADLESS") | not) | .name')
      mapfile -t ALL_HEADLESS < <(swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name')

      if [ "$HEADLESS_ACTIVE" != "true" ]; then
          # Entering streaming mode: bring up the requested headless output,
          # disable every physical output.
          swaymsg output "$HEADLESS" enable
          for mon in "''${ALL_PHYSICAL[@]}"; do
              swaymsg output "$mon" disable
          done
          swaymsg workspace 99
      else
          # Leaving streaming mode: bring back every physical output,
          # disable ALL headless outputs (not just the one we were using).
          for mon in "''${ALL_PHYSICAL[@]}"; do
              swaymsg output "$mon" enable
          done
          for mon in "''${ALL_HEADLESS[@]}"; do
              swaymsg output "$mon" disable
          done
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
    protontricks.enable = true;
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
          image-path = "${./sunshine-thumbnails/Steam-desktop.png}";
          prep-cmd = [
            {
              do = "${headlessToggle}/bin/headless-toggle HEADLESS-1";
              undo = "${headlessToggle}/bin/headless-toggle HEADLESS-1";
            }
            {
              do = "${pkgs.steam}/bin/steam -shutdown";
            }
            {
              do = "sleep 10";
            }
          ];
        }
        {
          name = "Steam iPad";
          detached = [
            "${pkgs.gamescope}/bin/gamescope -e -H 1640 -W 2360 -r 60 -- ${pkgs.steam}/bin/steam -gamepadui"
          ];
          image-path = "${./sunshine-thumbnails/Steam-iPad.png}";
          prep-cmd = [
            {
              do = "${headlessToggle}/bin/headless-toggle HEADLESS-2";
              undo = "${headlessToggle}/bin/headless-toggle HEADLESS-2";
            }
            {
              do = "${pkgs.steam}/bin/steam -shutdown";
            }
            {
              do = "sleep 10";
            }
          ];
        }
        {
          name = "Desktop Desktop";
          image-path = "${./sunshine-thumbnails/Desktop-Desktop.png}";
          prep-cmd = [
            {
              do = "${headlessToggle}/bin/headless-toggle HEADLESS-1";
              undo = "${headlessToggle}/bin/headless-toggle HEADLESS-1";
            }
          ];
        }
        {
          name = "Desktop iPad";
          image-path = "${./sunshine-thumbnails/Desktop-iPad.png}";
          prep-cmd = [
            {
              do = "${headlessToggle}/bin/headless-toggle HEADLESS-2";
              undo = "${headlessToggle}/bin/headless-toggle HEADLESS-2";
            }
          ];
        }
      ];
    };
  };
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
}
