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
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells = {
        default = pkgs.mkShell {
#          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = with pkgs; [
            elixir_1_16
            erlang_26
          ];
        };
      };

      # packages = { default = ... };
    });
}
