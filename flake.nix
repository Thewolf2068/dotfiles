{
  description = "My Main NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Kotofetch (non-flake source)
    kotofetch-src = {
      url = "github:hxpe-dev/kotofetch";
      flake = false;
    };

    # Waybar (bleeding edge, kept separate for mango workspaces + cava support)
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };

    # Neovim
    nvf = {
      url = "github:notashelf/nvf"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Discord configuration
    nixcord.url = "github:4evy/nixcord";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, zen-browser, kotofetch-src, waybar, spicetify-nix, nvf, ... }@inputs: {
    nixosConfigurations.thinkpadofmiquella = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Overlays: kotofetch + waybar (built with mango workspaces + cava support)
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              kotofetch = final.callPackage kotofetch-src { };
            })
            (final: prev: {
              waybar = (prev.callPackage "${waybar}/nix/default.nix" {
                waybar = prev.waybar;
                version = waybar.shortRev or "dirty";
              }).overrideAttrs (old: {
                mesonFlags = (old.mesonFlags or []) ++ [
                  "-Dcava=enabled"
                  "-Dmango=true"
                ];
              });
            })
          ];
        })

        ./hosts/thinkpadofmiquella/configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.malenia = {
            imports = [
              ./hosts/thinkpadofmiquella/home.nix
              catppuccin.homeModules.catppuccin
              inputs.spicetify-nix.homeManagerModules.default
              inputs.nvf.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}
