{ inputs, pkgs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      OfferToSaveLogins = false;
    };

    profiles.default = {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "zen.workspaces.continue-where-left-off" = true;
        "browser.startup.page" = 3;
        "widget.transparent-windows" = false;
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = true;
      };

      presets = {
        catppuccin = {
          enable = true;
          flavor = "Mocha";
          accent = "Mauve";
        };

      };

      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          onepassword-password-manager
          imagus
          return-youtube-dislikes
          vimium
          stylus
          youtube-shorts-block
          old-reddit-redirect
          sponsorblock
          greasemonkey
          seventv
          betterttv
          indie-wiki-buddy
        ];
      };
    };
  };
}
