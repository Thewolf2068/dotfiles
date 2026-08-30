{ pkgs, ... }:

let
  workspaceManager = pkgs.writeShellApplication {
    name = "workspace-manager";
    runtimeInputs = [ pkgs.jq pkgs.sway ];
    text = ''
      TARGET=$1
      CURRENT_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

      # Only move if the workspace isn't already on the focused monitor
      WORKSPACE_OUTPUT=$(swaymsg -t get_workspaces | jq -r ".[] | select(.name == \"$TARGET\") | .output")

      if [ "$WORKSPACE_OUTPUT" != "$CURRENT_OUTPUT" ]; then
          swaymsg "workspace $TARGET; move workspace to output $CURRENT_OUTPUT"
      fi

      swaymsg "workspace $TARGET"
    '';
  };

  wmScript = "${workspaceManager}/bin/workspace-manager";
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx; # Enable once they fix it
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    checkConfig = false;

    extraConfig = ''
      shadows enable
      blur enable
      blur_radius 7
      blur_passes 2
      corner_radius 12
      # animation_duration_ms 200
    '';

    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      bars = [ ];

      startup = [
        { command = "zen-beta"; }
        { command = "swaymsg create_output HEADLESS-1"; }
        { command = "sh -c 'protonplus update all; exec steam -silent'"; }
        { command = "spotify"; }
        { command = "easyeffects --gapplication-service"; }
        { command = "kdeconnectd"; }
      ];

      gaps = {
        inner = 5;
        outer = 5;
      };

      keybindings = {
        "${modifier}+Q" = "exec ${terminal}";
        "${modifier}+D" = "exec noctalia msg panel-toggle launcher";

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

        "${modifier}+n" = "exec noctalia msg panel-toggle control-center notifications";
        "${modifier}+v" = "exec noctalia msg panel-toggle clipboard";
        "${modifier}+Shift+s" = "exec noctalia msg screenshot-region";
        "${modifier}+Alt+l" = "exec noctalia msg session lock";

        "${modifier}+p" = "exec noctalia msg panel-toggle session";

        # Media Keys
        "XF86AudioRaiseVolume" = "exec noctalia msg volume-up";
        "XF86AudioLowerVolume" = "exec noctalia msg volume-down";
        "XF86AudioMute" = "exec noctalia msg volume-mute";

        "XF86AudioPlay" = "exec playerctl --player=spotify play-pause";
        "XF86AudioNext" = "exec playerctl --player=spotify next";

        # Brightness
        "XF86MonBrightnessUp" = "exec noctalia msg brightness-up";
        "XF86MonBrightnessDown" = "exec noctalia msg brightness-down";

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
          bg = "${./images/wallpapers/mifulu/2.png} fill";
          pos = "2560 0";
        };

        "HKC OVERSEAS LIMITED E2721F 0000000000001" = {
          mode = "2560x1440@100Hz";
          bg = "${./images/wallpapers/mifulu/7.png} fill";
          pos = "0 0";
        };

        "HEADLESS-1" = {
          mode = "2560x1440@144Hz";
          bg = "${./images/wallpapers/special/moonlight-sunshine.png} fill";
          pos = "1000000 0";
          disable = "";
        };
      };

      window = {
        titlebar = false;
        border = 2;

        commands = [
          {
            command = "opacity 0.87";
            criteria.app_id = ".*";
          }

          {
            command = "opacity 0.87";
            criteria.class = ".*";
          }

          {
            command = "fullscreen enable, move container to workspace number 8, workspace number 8";
            criteria.title = "Steam Big Picture Mode";
          }

          {
            command = "fullscreen enable, move container to workspace 8, workspace 8";
            criteria.class = "steam_app_*";
          }

          {
            command = "floating enable";
            criteria = {
              class = "^steam$";
              title = "^(?!.*Steam).*$";
            };
          }

          {
            command = "opacity 0.7";
            criteria.app_id = "zen-beta";
          }

          # Clipse popup
          {
            command = "floating enable, resize set 622 652, move position center, border pixel 2, sticky enable, focus";
            criteria.app_id = "clipse";
          }
        ];
      };

      assigns = {
        "workspace \"4\"" = [ { app_id = "zen-beta"; } ];
        "workspace \"5\"" = [ { class = "Spotify"; } ];
        "workspace \"6\"" = [
          { app_id = "signal"; }
          { app_id = "vesktop"; }
        ];
        "workspace \"7\"" = [ { app_id = "kitty"; } ];
        "workspace \"8\"" = [ 
          { class = "steam"; }
          { class = "osu!"; }
        ];
      };
    };
  };

  services.autotiling.enable = true;
}
