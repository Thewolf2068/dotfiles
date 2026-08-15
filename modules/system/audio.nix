{ ... }:

{
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig."99-xm5-eq" = {
      "node.software-dsp.rules" = [
        {
          matches = [
            {
              "node.name" = "bluez_output.80_99_E7_2D_61_57.1";
            }
          ];

          actions = {
            "create-filter" = {
              "filter-graph" = {
                "node.description" = "WH-1000XM5 AutoEQ";
                "media.name" = "WH-1000XM5 AutoEQ";

                "filter.graph" = {
                  nodes = [
                    {
                      type = "builtin";
                      name = "eq";
                      label = "param_eq";

                      config = {
                        filters = [
                          {
                            type = "bq_lowshelf";
                            freq = 105.0;
                            gain = -3.6;
                            q = 0.70;
                          }
                          {
                            type = "bq_peaking";
                            freq = 57.2;
                            gain = 0.9;
                            q = 1.31;
                          }
                          {
                            type = "bq_peaking";
                            freq = 116.0;
                            gain = -1.3;
                            q = 2.06;
                          }
                          {
                            type = "bq_peaking";
                            freq = 185.2;
                            gain = -5.2;
                            q = 1.05;
                          }
                          {
                            type = "bq_peaking";
                            freq = 580.0;
                            gain = 1.9;
                            q = 1.77;
                          }
                          {
                            type = "bq_peaking";
                            freq = 1238.6;
                            gain = 3.5;
                            q = 2.30;
                          }
                          {
                            type = "bq_peaking";
                            freq = 2420.0;
                            gain = 7.1;
                            q = 1.77;
                          }
                          {
                            type = "bq_peaking";
                            freq = 3126.3;
                            gain = -5.4;
                            q = 2.89;
                          }
                          {
                            type = "bq_peaking";
                            freq = 6124.5;
                            gain = -2.9;
                            q = 5.15;
                          }
                          {
                            type = "bq_highshelf";
                            freq = 10000.0;
                            gain = 5.4;
                            q = 0.70;
                          }
                        ];
                      };
                    }
                  ];

                  inputs = [
                    "eq:In 1"
                    "eq:In 2"
                  ];

                  outputs = [
                    "eq:Out 1"
                    "eq:Out 2"
                  ];
                };

                "capture.props" = {
                  "node.name" = "xm5-eq-input";
                  "media.class" = "Audio/Sink";
                  "audio.channels" = 2;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };

                "playback.props" = {
                  "node.name" = "xm5-eq-output";
                  "node.passive" = true;
                  "audio.channels" = 2;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];

                  "target.object" =
                    "bluez_output.80_99_E7_2D_61_57.1";
                };
              };

              "hide-parent" = true;
            };
          };
        }
      ];

      "wireplumber.profiles" = {
        main = {
          "node.software-dsp" = "required";
        };
      };
    };
  };
}
