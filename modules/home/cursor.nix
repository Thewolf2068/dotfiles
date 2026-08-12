{ pkgs, ... }:

{
  home.pointerCursor = {
    name = "BreezeX-Black";
    package = pkgs.kdePackages.breeze;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
