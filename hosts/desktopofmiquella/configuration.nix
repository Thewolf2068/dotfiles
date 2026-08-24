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
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
  };




  networking.hostName = "desktopofmiquella";


  system.stateVersion = "26.05";
}
