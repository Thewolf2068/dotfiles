{ ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;


    extraConfig = 
      ''
        keybinds {
          normal {
            bind "Ctrl f" { ToggleFloatingPanes; }  
            bind "Ctrl d" { Detach; }
          }
        }
      '';
  };
}
