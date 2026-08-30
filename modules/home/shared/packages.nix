{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    fuzzel
    tree
    wl-clipboard
    swaybg
    signal-desktop
    kotofetch
    lswt
    jq
    eza
    playerctl
    wlr-randr
    fzf
    bat
    btop
    cava
    localsend
    opencode
    networkmanagerapplet
    pavucontrol
    wev
    tealdeer
    killall
    easyeffects
    _1password-gui
    solaar


    # Gaming
    supertuxkart
    mangohud
    protonplus
    lutris
    heroic
    prismlauncher
    limo
    deadlock-mod-manager
    faugus-launcher
    sgdboop
    osu-lazer-bin
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GI_TYPELIB_PATH = "${pkgs.playerctl}/lib/girepository-1.0";
  };
}
