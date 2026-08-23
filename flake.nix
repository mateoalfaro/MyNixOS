{
  description = "Jafed's NixOS desktop configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    singularity-desktop = {
      url = "path:/home/jafed/devwork/singularity-flake";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/001e560";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium.url = "github:schembriaiden/helium-browser-nix-flake";

    llm-agents.url = "github:numtide/llm-agents.nix";

    vicre.url = "path:/home/jafed/devwork/vicre";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      codex-cli,
      singularity-desktop,
      lanzaboote,
      helium,
      llm-agents,
      vicre,
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./imports.nix
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            singularity-desktop.nixosModules.default
            vicre.nixosModules.default
          ];
        };
      };

      packages.${system}.default = self.nixosConfigurations.nixos.config.system.build.toplevel;
    };
}
