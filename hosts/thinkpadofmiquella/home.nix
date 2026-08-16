{ config, pkgs, inputs, ... }:
{
  home.username = "malenia";
  home.homeDirectory = "/home/malenia";
  home.stateVersion = "26.05"; # match your nixos-version
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/catppuccin.nix
    ../../modules/home/sway.nix
    ../../modules/home/waybar.nix
    ../../modules/home/swaync.nix
    ../../modules/home/fastfetch.nix
    ../../modules/home/zsh.nix
    ../../modules/home/mango.nix
    ../../modules/home/swaylock.nix
    ../../modules/home/spotify.nix
    ../../modules/home/nvim.nix
    ../../modules/home/kitty.nix
    ../../modules/home/fuzzel.nix
    ../../modules/home/cursor.nix
    ../../modules/home/git.nix
    ../../modules/home/mangohud.nix
    ../../modules/home/discord.nix
    ../../modules/home/zen-browser.nix
  ];
}
