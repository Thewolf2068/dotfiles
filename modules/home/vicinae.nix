{ ... }:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true; # default: false
    };
    settings = {
      font = {
        normal = {
          size = 12;
          family = "Maple Nerd Font";
        };
      };
      launcher_window = {
        opacity = 0.9;
      };
    };
  };
}
