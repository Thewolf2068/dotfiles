{ inputs, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.equicord.enable = true;

    config = {
      enabledThemeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
      ];
      plugins = {
        fakeNitro.enable = true;
        declutter.enable = true;
      };
    };
  };
}
