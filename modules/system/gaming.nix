{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
  };

  # AMD GPU control - fan curves, power limits, clock offsets
  services.lact.enable = true;

  # Sunshine for game streaming
  services.sunshine = {
    enable = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Steam";
          detached = [
            "${pkgs.gamescope}/usr/bin/gamescope -e -H 1440 -W 2560 -r 144 -- ${pkgs.steam}/usr/bin/steam -gamepadui"
          ];
          prep-cmd = [
            {
              do = "${../home/scripts/headless_toggle.sh}";
              undo = "${../home/scripts/headless_toggle.sh}";
            }
            {
              do = "steam -shutdown";
            }
          ];
        }
      ];
    };
  };



        

  # Controller support beyond the default xpad-covered devices
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  environment.systemPackages = with pkgs; [
    mangohud
    protonplus
    lutris
    heroic
  ];
}
