{ pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    git
    wget
  ];
}
