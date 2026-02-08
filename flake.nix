{
  description = "A Nix flake for my machine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
    }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./imports.nix
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jafed = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
