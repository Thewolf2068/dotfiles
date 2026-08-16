{ inputs, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.equicord.enable = true;
    quickCss = ''
      @import url("https://croissantdunord.github.io/discord-adblock/adblock.css");
      @import url("https://croissantdunord.github.io/discord-adblock/adblock-extras.css");
      /* Hide Quests Button */
      [href='/quest-home'] {
          display: none;
      }
    '';
    config = {
      enabledThemeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
      ];
      plugins = {
        fakeNitro.enable = true;
        declutter.enable = true;
      };
      useQuickCss = true;
    };
  };
}
