{ pkgs, ... }:
{

  programs.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with pkgs.emacs-gtk if desired
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.nixfmt
        epkgs.evil
        epkgs.evil-collection
      ];
    extraConfig = ''
      (setq standard-indent 2)

      (require 'evil)
      (evil-mode 1)

      (evil-collection-init)
      '';
  };
}
