{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ".." = "cd ..";
      "clear" = "clear && kotofetch";
      "ff" = "fastfetch";
      "ls" = "eza --icons --color=always --group-directories-first";
      "ll" = "eza -alF --icons --color=always --group-directories-first";
      "la" = "eza -a --icons --color=always --group-directories-first";
      "l" = "eza -lF --icons --color=always --group-directories-first";
      "vi" = "nvim";
      "cat" = "bat";
    };
    initContent = ''
      fastfetch
      set -o emacs
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[3~" delete-char
      bindkey -s "^L" "\clear^M"
      '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };
}
