# { config, pkgs, inputs, ... }: 
#
# {
#   imports = [
#     # Import the Home Manager module from the flake
#     inputs.caelestia-shell.homeManagerModules.default
#   ];
#
#   programs.caelestia = {
#     enable = true;
#
#     # Highly recommended: required for IPC commands and full functionality
#     cli.enable = true; 
#
#     # Declarative configuration (maps directly to ~/.config/caelestia/shell.json)
#     # Any omitted values will automatically fall back to their defaults
#     # settings = {
#     #   enabled = true;
#     #   general = {
#     #     idle.lockBeforeSleep = true;
#     #   };
#     #   bar = {
#     #     persistent = true;
#     #     workspaces.shown = 5;
#     #   };
#     # };
#   };
# }
