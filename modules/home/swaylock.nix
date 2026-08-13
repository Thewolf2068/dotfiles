{ pkgs, ... }:

let
  swaylockOpts = "--screenshots --clock --indicator --indicator-radius 100 --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.1 -f";
  swaylockIdle = "${pkgs.swaylock}/bin/swaylock ${swaylockOpts} --grace 2";
  swaylockSleep = "${pkgs.swaylock}/bin/swaylock ${swaylockOpts}";
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };
  services.swayidle = {
    enable = true;
    systemdTarget = "mango-session.target";
    events = [
      { event = "before-sleep"; command = swaylockSleep; }
      { event = "lock"; command = swaylockIdle; }
    ];
    timeouts = [
      { timeout = 300; command = swaylockIdle; }
    ];
  };
}
