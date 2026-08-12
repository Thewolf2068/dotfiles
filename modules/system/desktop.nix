{ pkgs, ... }:
{
  environment.pathsToLink = [ "/libexec" ];
  services.xserver.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.polkit.enable = true;

  programs.sway.enable = true;
  programs.mango.enable = true;   # renamed per the eval warning you got

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
    wlr.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [ kdePackages.qtmultimedia ];
    };
    sessionPackages = [ pkgs.river ];
    defaultSession = "sway";
  };

  environment.systemPackages = [
    (pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
    })
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };


  services.printing.enable = true;
}
