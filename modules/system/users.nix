{ pkgs, ... }:
{
  users.users."malenia" = {
    isNormalUser = true;
    description = "malenia";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  programs.starship.enable = true;
}
