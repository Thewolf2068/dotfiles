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
    applications = {
      apps = [
        {
          name = "Steam";
          prep-cmd = [
            {
              do = "steam -shutdown";
            }
          ];
          cmd = "steam";
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
