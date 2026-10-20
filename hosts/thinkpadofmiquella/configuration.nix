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
      ../../modules/system/virtualization.nix
      ../../modules/system/amd.nix
      ../../modules/system/ollama.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
  };

  services.upower.enable = true;

  # For dock
  services.hardware.bolt.enable = true;

  networking.hostName = "thinkpadofmiquella";
  networking.wireless.enable = true;

  system.stateVersion = "26.05";
}
