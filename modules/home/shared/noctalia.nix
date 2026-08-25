{ ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell = {
        font = "JetBrainsMono Nerd Font";
        settings_show_advanced = true;
      };
      theme = {
        mode = "dark";
        source = "community";
        community_palette = "Catppuccin Mocha Mauve-Lavender";
      };


      bar.default.enabled = false;
      bar.top = {
        background_opacity = 0.9;
        enabled = true;
        position = "top";
        concave_edge_corners = false;
        margin_edge = 4;
        margin_ends = 5;
        start  = ["audio-vis" ];
        end = ["media" "session" ];
      };
      bar.bottom = {
        enabled = true;
        background_opacity = 0.9;
        position = "bottom";
        concave_edge_corners = true;
        margin_ends = 400;
        start = [ "cpu" "gpu" "ram" "weather" ];
        center = [ "workspaces" ];
        end = [ "network" "volume" "bluetooth" "battery" "notifications" ];
      };

      wallpaper.enabled = false;

      location = {
        auto_locate = true;
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        blurred_desktop = true;
        blur_intensity = 0.8;
        tint_intensity = 0.5;
      };

      widget = {
        workspaces = {
          show_labels = false;
        };
        audio-vis = {
          type = "audio_visualizer";
          width = 182;
          bands = 64;
        };
        clock = {
          format = "{:%b %d} {:%H:%M}";
        };
        media = {
          max_length = 300;
          hide_when_no_media = true;
          title_scroll = "always";
          art_size = 24;
          artist_first = true;
        };
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "graph";
          show_value = false;
        };
        gpu = {
          type = "sysmon";
          stat = "gpu_usage";
          visualization = "graph";
          show_value = false;
        };
        ram = {
          type = "sysmon";
          stat = "ram_pct";
          visualization = "graph";
          show_value = false;
        };
        volume = {
          show_label = false;
        };
        network = {
          show_label = false;
        };
        battery = {
          display_mode = "graphic";
          show_label = false;
        };
      };
    };
  };
}
