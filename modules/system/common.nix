{ ... }:
{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
