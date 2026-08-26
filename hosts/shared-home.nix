{ ... }:
{
  home.username = "malenia";
  home.homeDirectory = "/home/malenia";
  home.stateVersion = "26.05"; # match your nixos-version
  imports = [
    ../modules/home/shared/packages.nix
    ../modules/home/shared/catppuccin.nix
    ../modules/home/shared/sway.nix
    ../modules/home/shared/noctalia.nix
    ../modules/home/shared/fastfetch.nix
    ../modules/home/shared/zsh.nix
    ../modules/home/shared/spotify.nix
    ../modules/home/shared/nvim.nix
    ../modules/home/shared/kitty.nix
    ../modules/home/shared/cursor.nix
    ../modules/home/shared/git.nix
    ../modules/home/shared/mangohud.nix
    ../modules/home/shared/discord.nix
    ../modules/home/shared/zen-browser.nix
    ../modules/home/shared/polkit-agent.nix
  ];
}
