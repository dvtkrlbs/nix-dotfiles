{
  description = "<ADD YOUR DESCRIPTION>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    pre-commit-hooks,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            convco.enable = true;
            eslint.enable = true;
            markdownlint.enable = true;
            taplo.enable = true;
          };
          # tools = {inherit (rustPackages) cargo clippy rustfmt;};
        };
      };
      devShells = {
        default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = with pkgs;
            [
              gcc
              nodejs
              nodePackages.pnpm
            ]
            ++ lib.optionals stdenv.isDarwin [
              # libiconv
              # darwin.apple_sdk.frameworks.Security
            ];
        };
      };

      # packages = { default = ... };
    });
}
