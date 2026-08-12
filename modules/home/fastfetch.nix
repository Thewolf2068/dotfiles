{ ... }:

let
  esc = builtins.fromJSON ''"\u001b"'';
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        source = "${./images/fastfetch/kuromi.png}";
        type = "kitty";
        height = 19;
        padding = {
          top = 2;
        };
      };
      general = {
        playerName = "tauon";
      };
      display = {
        separator = " ";
      };
      modules = [
        "break"
        "break"
        "break"
        {
          type = "custom";
          format = "${esc}[90m  ${esc}[31m  ${esc}[32m  ${esc}[33m  ${esc}[34m  ${esc}[35m  ${esc}[36m  ${esc}[37m ";
        }
        "break"
        {
          type = "title";
          keyWidth = 10;
        }
        "break"
        {
          type = "os";
          key = " ";
          keyColor = "34"; # = color4
        }
        {
          type = "kernel";
          key = " ";
          keyColor = "34";
        }
        {
          type = "packages";
          key = " ";
          keyColor = "34";
        }
        {
          type = "shell";
          key = " ";
          keyColor = "34";
        }
        {
          type = "terminal";
          key = " ";
          keyColor = "34";
        }
        {
          type = "wm";
          key = " ";
          keyColor = "34";
        }
        {
          type = "cursor";
          key = " ";
          keyColor = "34";
        }
        {
          type = "terminalfont";
          key = " ";
          keyColor = "34";
        }
        {
          type = "uptime";
          key = " ";
          keyColor = "34";
        }
        {
          type = "datetime";
          format = "{1}-{3}-{11}";
          key = " ";
          keyColor = "34";
        }
        {
          type = "media";
          key = "󰝚 ";
          keyColor = "34";
        }
        {
          type = "player";
          key = " ";
          keyColor = "34";
        }
        "break"
        {
          type = "custom";
          format = "${esc}[90m  ${esc}[31m  ${esc}[32m  ${esc}[33m  ${esc}[34m  ${esc}[35m  ${esc}[36m  ${esc}[37m ";
        }
        "break"
        "break"
      ];
    };
  };
}
