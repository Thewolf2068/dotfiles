{ pkgs, ... }:

{
  catppuccin = {
    cache.enable = true;
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };


  # QT/Kvantum
  qt = {
    enable = true;
    kvantum = {
      enable = true;
      settings.General = {
        theme = "catppuccin-mocha-mauve";
      };
    };
    style.name = "kvantum";
  };

  # GTK
  gtk = {
    gtk4 = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "standard";
          tweaks = [ ];
          variant = "mocha";
        };
      };
    };
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ ];
        variant = "mocha";
      };
    };
  };
}
