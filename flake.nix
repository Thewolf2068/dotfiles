{
  description = "My Main NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

      catppuccin.url = "github:catppuccin/nix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake"; inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kotofetch-src = {
      url = "github:hxpe-dev/kotofetch";
      flake = false;
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:4evy/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swayfx-src = {
      url = "github:wlrfx/swayfx";
      flake = false;
    };

    # Decky/Steam deck
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, catppuccin, zen-browser, kotofetch-src, spicetify-nix, nvf, nur, jovian, ... }@inputs:
    let
      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          inputs.nur.overlays.default
          (final: prev: {
            kotofetch = final.callPackage kotofetch-src { };
          })
          (final: prev: {
            swayfx-unwrapped = prev.swayfx-unwrapped.overrideAttrs (old: {
              version = "git-${inputs.swayfx-src.shortRev or "dirty"}";
              src = inputs.swayfx-src;
            });
          })
        ];
      };

      # Builds one host's nixosSystem given its hostname (used for both the
      # configuration.nix and home.nix paths under ./hosts/<hostname>/)
      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            overlaysModule
            ./hosts/${hostname}/configuration.nix
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            jovian.nixosModules.default
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.malenia = {
                imports = [
                  ./hosts/${hostname}/home.nix
                  ./hosts/shared-home.nix
                  catppuccin.homeModules.catppuccin
                  inputs.spicetify-nix.homeManagerModules.default
                  inputs.nvf.homeManagerModules.default
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations.thinkpadofmiquella = mkHost "thinkpadofmiquella";
      nixosConfigurations.desktopofmiquella = mkHost "desktopofmiquella";
    };
}
