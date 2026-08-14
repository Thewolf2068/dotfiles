{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        "margin-top" = 5;
        "margin-left" = 5;
        "margin-right" = 5;
        "margin-bottom" = 5;
        reload_style_on_change = true; layer = "top";

        # Modules Layout
        modules-left = [
          "custom/os"
          "mango/workspaces"
        ];
        
        modules-center = [
          "custom/media"
        ];
        
        modules-right = [
          "custom/headsetVolume"
          "tray"
          "bluetooth"
          "network"
          "clock"
          "battery"
          "group/volume"
          "custom/power"
        ];

        # Module Configurations
        "custom/media" = {
          format = "{icon} {text}";
          return-type = "json";
          escape = true;
          "hide-empty-text" = true;
          "on-click" = "/usr/bin/env swayosd-client --player 'spotify'  --playerctl play-pause";
          exec = "/usr/bin/env python3 ${./scripts/waybar/mediaplayer.py} --player spotify 2> /dev/null";
        };

        bluetooth = {
          format = "";
          "format-disabled" = "";
          "format-connected" = " {num_connections}";
          "tooltip-format" = "{controller_alias}\t{controller_address}";
          "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          "on-click" = "${pkgs.blueman}/bin/blueman";
        };

        "group/volume" = {
          orientation = "horizontal";
          drawer = {
            "transition-duration" = 500;
          };
          modules = [
            "pulseaudio"
            "pulseaudio/slider"
          ];
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "custom/power" = {
          format = "󰤆";
          "on-click" = "${./scripts/fuzzel/powermenu.sh}";
          tooltip = false;
        };

        "mango/workspaces" = {
          hide-empty = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "default" = " ";
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = " ";
            "5" = " ";
            "6" = "󱋊 ";
            "7" = " ";
            "8" = "󰊴 ";
          };
        };

        "river/window" = {
          format = "{app_id}";
          "max-length" = 50;
          "all-outputs" = true;
          "offscreen-css" = true;
          "offscreen-css-text" = "(inactive)";
          rewrite = {
            "(.*) - Mozilla Firefox" = " $1";
            "(.*) - fish" = "> [$1]";
          };
        };

        "custom/os" = {
          format = "<span size='large' color='#179299'>  </span>";
          "tooltip-format" = "btw";
        };

        tray = {
          "icon-size" = 21;
          spacing = 7;
          "show-passive-items" = true;
        };

        pulseaudio = {
          format = "{icon}";
          "tooltip-format" = "{volume}%";
          "format-muted" = " ";
          "format-icons" = {
            default = [ " " " " ];
          };
          "on-click" = "pavucontrol";
          "on-click-right" = "pactl -- set-sink-volume 0 100%";
        };

        clock = {
          format = "<span color='#b4befe'>  </span>{:%H:%M}";
          tooltip = true;
          "tooltip-format" = "{:%d/%m/%Y}";
          "on-click" = "gnome-calendar";
        };

        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          "format-icons" = {
            default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            charging = [ "󰂄" ];
          };
          "max-length" = 25;
        };

        network = {
          "format-wifi" = "   {signalStrength}%";
          "format-ethernet" = "󰈀   Wired";
          "format-disconnected" = "󰤮   Offline";
          "tooltip-format-wifi" = "SSID: {essid}\nIP: {ipaddr}\nFreq: {frequency} MHz\n󰇚 {bandwidthDownBytes} | 󰕒 {bandwidthUpBytes}";
          "tooltip-format-ethernet" = "Interface: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}\n󰇚 {bandwidthDownBytes} | 󰕒 {bandwidthUpBytes}";
          "tooltip-format-disconnected" = "No network connection";
          "max-length" = 10;
          "on-click" = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };
      };
    };

    style = ''
      @define-color border @sky;
      @define-color text @teal;

      /* -----------------------------------------------------------------------------
       * Global Reset & Font
       * -------------------------------------------------------------------------- */
      * {
          border: none;
          border-radius: 0;
          font-family: "FiraCode Nerd", "Sofia Pro", sans-serif, FontAwesome;
          font-size: 15px;
          min-height: 0;
      }

      window#waybar {
          background: transparent;
      }

      tooltip {
          background: @base;
          border: 2px solid @overlay0;
          border-radius: 0;
      }
      tooltip label {
          color: @text;
      }

      /* -----------------------------------------------------------------------------
       * Module Styles
       * -------------------------------------------------------------------------- */

      #custom-os,
      #pulseaudio,
      #river-window,
      #window,
      #custom-media,
      #custom-headsetVolume,
      #tray,
      #custom-updates,
      #clock,
      #battery,
      #network,
      #backlight,
      #custom-power,
      #bluetooth,
      #cava,
      #pulseaudio-slider {
          background-color: alpha(@base, 1);
          color: @text;
          padding: 4px 14px;
          margin: 4px 2px 0 2px;
          border: 2px solid @border;
      }

      /* -----------------------------------------------------------------------------
       * Workspaces
       * -------------------------------------------------------------------------- */
      #workspaces {
          background-color: alpha(@base, 1);
          margin: 4px 2px 0 2px;
          padding: 0 4px;
          border: 2px solid @border;
      }

      #workspaces button {
          padding: 0 6px;
          margin: 0;
          background-color: transparent;
          color: @text;
          box-shadow: inset 0 -2px transparent;
          transition: all 0.15s ease;
      }

      #workspaces button.active {
          box-shadow: inset 0 -2px @mauve;
          color: @mauve;
      }

      #workspaces button.urgent {
          box-shadow: inset 0 -2px @red;
          color: @red;
      }

      #workspaces button:hover {
          box-shadow: inset 0 -2px @teal;
          color: @teal;
      }

      /* -----------------------------------------------------------------------------
       * Specific Module Tweaks
       * -------------------------------------------------------------------------- */

      #custom-os {
          color: @teal;
          /* padding: 0px 16px; */
      }

      #pulseaudio {
          color: @teal;
      }

      #custom-power {
          color: @red;
      }

      #window {
          font-weight: bold;
      }

      #clock {
          font-weight: bold;
          padding: 4px 16px;
      }

      #battery.charging, #battery.plugged {
          color: @green;
      }

      #battery.critical:not(.charging) {
          color: @red;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #network.disconnected {
          color: @red;
      }

      #pulseaudio.muted {
          color: @red;
      }

      #wireplumber.muted {
          background-color: @red;
      }

      #temperature.critical {
          background-color: @red;
      }

      /* -----------------------------------------------------------------------------
       * Sliders
       * -------------------------------------------------------------------------- */

      #pulseaudio-slider {
          padding: 4px 10px;
      }

      #pulseaudio-slider trough {
          min-height: 10px;
          min-width: 80px;
          border-radius: 0;
          background-color: @surface0;
      }

      #pulseaudio-slider highlight {
          min-width: 10px;
          border-radius: 0;
          background-color: @text;
      }

      /* -----------------------------------------------------------------------------
       * Animations
       * -------------------------------------------------------------------------- */
      @keyframes blink {
          to {
              background-color: @text;
              color: @base;
          }
      }
    '';
  };

  systemd.user.services.waybar= {
    Unit = {
      Description = "Waybar";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/env waybar";
      ExecStartPre = "/usr/bin/env sleep 2";
      Restart = "on-failure";
    };
    Service.Environment = [
      "GI_TYPELIB_PATH=${pkgs.playerctl}/lib/girepository-1.0"
    ];
  };

}
