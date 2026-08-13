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
    playerctl
    (pkgs.python3.withPackages (ps: with ps; [
      pygobject3
    ]))
    gobject-introspection
    wlr-randr
    fzf
    bat
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GI_TYPELIB_PATH = "${pkgs.playerctl}/lib/girepository-1.0";
  };
}
