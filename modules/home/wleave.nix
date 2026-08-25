{ pkgs, ... }:

{
  programs.wleave = {
    enable = true;
    settings  = {
      margin = 200;
      buttons-per-row = "1/1";
      delay-command-ms = 100;
      close-on-lost-focus = true;
      show-keybinds = true;
      buttons = [
      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
        icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
      }
      {
        label = "logout";
        action = "swaymsg exit";
        text = "Logout";
        keybind = "e";
        icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
        icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
        icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";

      }
      ];
    };
  };
}
