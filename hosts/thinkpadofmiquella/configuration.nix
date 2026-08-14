{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix
    ../../modules/system/networking.nix
    ../../modules/system/keyd.nix
    ../../modules/system/audio.nix
    ../../modules/system/desktop.nix
    ../../modules/system/locale.nix
    ../../modules/system/users.nix
    ../../modules/system/fonts.nix
    ../../modules/system/gaming.nix
    ../../modules/system/packages.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      AutoConnectTimeout = 30;
      ReconnectAttempts = 7;
      ReconnectIntervals = "1,2,4,8,16,32,64";
    };
  };

  services.blueman.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # For dock
  services.hardware.bolt.enable = true;

  networking.hostName = "thinkpadofmiquella";
  networking.wireless.enable = true;


  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "26.05";
}
