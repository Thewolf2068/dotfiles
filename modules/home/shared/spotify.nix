{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
      spicyLyrics
    ];
    enabledSnippets = [
      ''
        {
          "title": "Hide lyrics button",
          "description": "Hides the lyrics button in the playbar",
          "code": ".main-nowPlayingBar-lyricsButton { display: none; }",
          "preview": "resources/assets/snippets/hide-lyrics-button.png"
        }
      ''
    ];
  };

}
  
