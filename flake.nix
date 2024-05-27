{
  description = "Dvtkrlbs' Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # flake-utils.url = "github:numtide/flake-utils";
    flake-utils.url = "github:numtide/flake-utils";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

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

    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for the nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable nix-darwin modules you might want to export
    # These are usually stuff you would upstream into nix-darwin
    darwinModules = import ./modules/darwin;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;
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
          agenix.nixosModules.default
          ./hosts/darwin/mba.nix
          inputs.home-manager.darwinModules.home-manager
          # inputs.nixvim.homeManagerModules.nixvim
          {
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
# homeConfigurations = {
#   "dvtkrlbs@mba" = home-manager.lib.homeManagerConfiguration {
#     pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
#     extraSpecialArgs = {inherit inputs ;};
#     modules = [
#       ./home-manager/home-mba.nix
#     ];
#   };
# };
#   "david@beast" = home-manager.lib.homeManagerConfiguration {
#     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
#     extraSpecialArgs = {inherit inputs outputs;};
#     modules = [
#       ./home-manager/home-beast.nix
#     ];
#   };
# };
#  }
#// flake-utils.lib.eachSystem [
#      "aarch64-darwin"
#      "x86_64-linux"
#      "x86_64-darwin"
#    ] (system:
#      let
#        pkgs = import nixpkgs {inherit system; overlays = self.overlays; };
#      in rec {
#        packages = import ./pkgs pkgs;
#      }
#    );
#}

