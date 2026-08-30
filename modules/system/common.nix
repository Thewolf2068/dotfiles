{ ... }:
{
    nix = {
      optimise.automatic = true;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };
    hardware.logitech.wireless.enable = true;
    services.flatpak.enable = true;
    services.power-profiles-daemon.enable = true;
    programs.kdeconnect.enable = true;

    zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "lz4";
        memoryPercent = 50;
    };
    virtualisation.libvirtd.enable = true;
      nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 30d";
      };

}
