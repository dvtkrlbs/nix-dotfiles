{
  description = "Dvtkrlbs' Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # flake-utils.url = "github:numtide/flake-utils";
    flake-utils.url = "github:numtide/flake-utils";


    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hw.url = "github:nixos/nixos-hardware";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    lanzaboote.url = "github:nix-community/lanzaboote";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    flake-utils,
    nixos-wsl,
    agenix,
    nixos-generators,
    lanzaboote,
    lix-module,
    ...
  } @ inputs: let
    # inherit (self) outputs;
    supportedSystems = [
      flake-utils.lib.system.aarch64-darwin
      flake-utils.lib.system.x86_64-linux
      flake-utils.lib.system.x86_64-darwin
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    # Custom packages
    # Acessible through 'nix build', 'nix shell', etc

    # Formatter for the nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    templates = import ./templates;
    # templates = {
    #   node = {
    #     path = ./templates/node;
    #     description = "A getting started template for a new Nix project";
    #   };
    # };

    # nixosConfigurations = {
    #   n-wsl = nixpkgs.lib.nixOsSystem {
    #     system = "x86_64-linux";
    #     specialArgs = {inherit inputs ;};

    #   };
    # };
    nixosConfigurations = {
      "beast-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          lix-module.nixosModules.default
          agenix.nixosModules.default
          inputs.nixos-wsl.nixosModules.wsl
          inputs.vscode-server.nixosModules.default
          ./hosts/wsl/beast.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.dvtkrlbs = {
              imports = [
                # inputs.nixvim.homeManagerModules.nixvim
                ./home-manager/home-beast-wsl.nix
              ];
            };
          }

        ];
      };

      "fatass" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          lix-module.nixosModules.default
          agenix.nixosModules.default
          ./hosts/fatass.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.dvtkrlbs = {
              imports = [
                ./home-manager/home-fatass.nix
              ];
            };
          }
        ];
      };

      "lycalopex" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          lix-module.nixosModules.default
          agenix.nixosModules.default
          inputs.hw.nixosModules.raspberry-pi-4
          ./hosts/lycalopex.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.dvtkrlbs = {
              imports = [
                ./home-manager/home-lycalopex.nix
              ];
            };
          }
        ];
      };

      "beast" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          lix-module.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          ./hosts/beast.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.dvtkrlbs = {
              imports = [
                ./home-manager/home-beast.nix
              ];
            };
          }
        ];
      };

      "mastodon-prox" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          nixos-generators.nixosModules.all-formats
          ./hosts/modules/authorized-keys.nix
          ./hosts/modules/nix-settings.nix
          ./hosts/modules/prox.nix
          ./hosts/prox/mastodon.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.dvtkrlbs = {
              imports = [
                ./home-manager/home-prox.nix
              ];
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      "mba" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
       #   lix-module.nixosModules.default
          agenix.nixosModules.default
          ./hosts/darwin/mba.nix
          inputs.home-manager.darwinModules.home-manager
          # inputs.nixvim.homeManagerModules.nixvim
          {
	    home-manager.backupFileExtension = "backup";	
            home-manager.users.dvtkrlbs = {
              imports = [
                # inputs.nixvim.homeManagerModules.nixvim
                ./home-manager/home-mba.nix
              ];
            };
          }
        ];
      };
    };

    lycalopex-image = inputs.nixos-generators.nixosGenerate {
      system = "aarch64-linux";
      format = "sd-aarch64";
      modules = [
        inputs.hw.nixosModules.raspberry-pi-4
        ./hosts/lycalopex.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users.dvtkrlbs = {
            imports = [
              ./home-manager/home-lycalopex.nix
            ];
          };
        }
      ];
    };
  };
}
