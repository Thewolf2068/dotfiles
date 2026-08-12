{ pkgs, inputs, system, ... }:
{
  home.packages = with pkgs; [
    neovim              # unless you want nvim.nix to own this via programs.neovim
    foot
    kitty
    rofi
    fuzzel
    tree
    wl-clipboard
    amberol
    inputs.zen-browser.packages."${pkgs.system}".default
    swaybg
    vesktop
    signal-desktop
    zed-editor
    swaynotificationcenter
    nil
    nixd
    libnotify
    swayosd
    kotofetch
    zsh-autosuggestions
    zsh-syntax-highlighting
    river
    lswt
    swaylock-effects
    jq
    eza
  ];

  home.sessionVariables.EDITOR = "nvim";
}
