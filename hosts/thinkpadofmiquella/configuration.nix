{ inputs, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/keyd.nix
    ../../modules/system/audio.nix
    ../../modules/system/desktop.nix
    ../../modules/system/locale.nix
    ../../modules/system/users.nix
    ../../modules/system/fonts.nix
    ../../modules/system/gaming.nix
    ../../modules/system/packages.nix
  ];

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x400"
      "amdgpu.psr=0"
  ];

  networking.hostName = "thinkpadofmiquella";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;


  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "26.05";
}
