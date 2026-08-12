{ pkgs, ... }:

let
  breezeXBlack = pkgs.stdenvNoCC.mkDerivation {
    pname = "breezex-black";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz";
      hash = "sha256-dzt1UjdIFzQJ7mIoQbD3Sx6AYXpcWz3LtTp6w9BswjM=";
    };

    installPhase = ''
      mkdir -p $out/share/icons/BreezeX-Black
      cp -r ./. $out/share/icons/BreezeX-Black/
    '';
  };
in
{
  home.pointerCursor = {
    package = breezeXBlack;
    name = "BreezeX-Black";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "BreezeX-Black";
    cursor_theme = "BreezeX-Black";
    XCURSOR_SIZE = "24";
    cursor_size = "24";

  };
}
