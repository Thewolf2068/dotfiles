{ pkgs, ... }:

let
  wmScript = "${./scripts/workspace_manager.sh}";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      checkConfig = false;
    package = pkgs.swayfx;

    extraConfig = ''
      shadows enable
      blur enable
      blur_radius 7
      blur_passes 2
      corner_radius 5
      '';
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      bars = [ ];

      startup = [
<<<<<<< HEAD
      { command = "zen-beta"; }
      { command = "swaymsg create_output HEADLESS-1"; }
      { command = "swayosd-server"; }
      { command = "swaync"; }
=======
        { command = "zen-beta"; }
        { command = "swaymsg create_output HEADLESS-1"; }
        { command = "swayosd-server"; }
        { command = "swaync"; }
        { command = "sh -c 'protonplus update all; exec steam -silent'"; }
>>>>>>> 35eb84460c352d1d5f3e92256ac3db063aeb2c7a
      ];

      gaps.inner = 5;

      keybindings = {
        "${modifier}+Q" = "exec ${terminal}";
        "${modifier}+D" = "exec fuzzel";

        "${modifier}+Shift+C" = "reload";
        "${modifier}+C" = "kill";

        "${modifier}+F" = "fullscreen";
        "${modifier}+T" = "floating toggle";

        "${modifier}+Tab" = "workspace back_and_forth";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+N" = "exec swaync-client -t";

# Swayosd shenanigans
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise --max-volume 100";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower --max-volume 100";

        "--release Caps_Lock" = "exec swayosd-client --caps-lock";

        "XF86MonBrightnessUp" = "exec swayosd-client --brightness +5";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness -5";

        "XF86AudioPlay" = "exec swayosd-client --player \"spotify\" --playerctl play-pause";
        "XF86AudioNext" = "exec swayosd-client --player \"spotify\" --playerctl next";


# Trigger to switch into the summon mode
        "${modifier}+space" = "mode \"summon\"";
      };

      modes = {
        summon = {
          "1" = "exec ${wmScript} \"1\"; mode \"default\"";
          "2" = "exec ${wmScript} \"2\"; mode \"default\"";
          "3" = "exec ${wmScript} \"3\"; mode \"default\"";

          "b" = "exec ${wmScript} \"4\"; mode \"default\"";
          "s" = "exec ${wmScript} \"5\"; mode \"default\"";
          "d" = "exec ${wmScript} \"6\"; mode \"default\"";
          "k" = "exec ${wmScript} \"7\"; mode \"default\"";
          "g" = "exec ${wmScript} \"8\"; mode \"default\"";

          "Shift+1" = "move container to workspace \"1\"; mode \"default\"";
          "Shift+2" = "move container to workspace \"2\"; mode \"default\"";
          "Shift+3" = "move container to workspace \"3\"; mode \"default\"";

          "Shift+b" = "move container to workspace \"4\"; mode \"default\"";
          "Shift+s" = "move container to workspace \"5\"; mode \"default\"";
          "Shift+d" = "move container to workspace \"6\"; mode \"default\"";
          "Shift+k" = "move container to workspace \"7\"; mode \"default\"";
          "Shift+g" = "move container to workspace \"8\"; mode \"default\"";

          "Return" = "mode \"default\"";
          "Escape" = "mode \"default\"";
        };
      };

      output = {
        eDP-1 = {
          mode = "1920x1200@60Hz";
          bg = "${./images/wallpapers/mifulu/5.png} fill";
          adaptive_sync = "off";
        };
        "LG Electronics LG ULTRAGEAR 407NTVS68263" = {
          mode = "2560x1440@144Hz";
          pos = "2560 0";
        };
        "HKC OVERSEAS LIMITED E2721F 0000000000001" = {
          mode = "2560x1440@100Hz";
          pos = "0 0";
        };
        "HEADLESS-1" = {
          mode = "2560x1440@144Hz";
          pos = "1000000 0";
          disable = "";
        };
      };

      window = {
        titlebar = false;
        border = 2;
        commands = [
        { command = "opacity 0.87"; criteria.app_id = ".*"; }
        { command = "opacity 0.87"; criteria.class = ".*"; }
        {
          command = "fullscreen enable, move container to workspace number 99, workspace number 99";
          criteria.title = "Steam Big Picture Mode";
        }
        {
          command = "fullscreen enable, move container to workspace Games, workspace Games";
          criteria.class = "steam_app_*";
        }
        {
          command = "floating enable";
          criteria = {
            class = "^steam$";
            title = "^(?!.*Steam).*$";
          };
        }
        ];
      };

      assigns = {
        "workspace \"4\"" = [ { app_id = "zen-beta"; } ];
        "workspace \"5\""   = [ { app_id = "feishin"; } ];
        "workspace \"6\""  = [ { app_id = "signal"; } { app_id = "vesktop"; } ];
        "workspace \"7\""   = [ { app_id = "kitty"; } ];
        "workspace \"8\""   = [ { class = "steam"; } ];
      };
    };
  };
}
