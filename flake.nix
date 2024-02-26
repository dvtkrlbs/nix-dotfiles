{
  description = "Dvtkrlbs' Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    # nix-colors.url = "github:misterio77/nix-colors";

    # nix-relic.url = "github:DavSanchez/Nix-Relic";
    # nix-relic.inputs.nixpkgs.follows = "nixpkgs";

    # Editors
    ## NixVim
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # url = "github:nix-community/nixvim/nixos-23.05";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    supportedSystems = [
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
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

    nixosConfigurations = {
      n-wsl = nixpkgs.lib.nixOsSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs ;};
        modules = [
          ./hosts/wsl/beast.nix
        ];
      };
    };

    darwinConfigurations = {
      "mba" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/darwin/mba.nix
          inputs.home-manager.darwinModules.home-manager
          { home-manager.users.dvtkrlbs = import ./home-manager/home-mba.nix; }
        ];
      };
    };

    # homeConfigurations = {
    #   "dvtkrlbs@mba" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
    #     extraSpecialArgs = {inherit inputs ;};
    #     modules = [
    #       ./home-manager/home-mba.nix
    #     ];
    #   };
    #   "david@beast" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
    #     extraSpecialArgs = {inherit inputs outputs;};
    #     modules = [
    #       ./home-manager/home-beast.nix
    #     ];
    #   };
    # };
  };
}
