# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  # inputs,
  # pkgs,
  ...
}: {

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # # You can also split up your configuration and import pieces of it here:
    # ./features/aws
    # ./features/common.nix
    ./features/cli
    ./features/dev
    ./features/direnv
    # # # ./features/emacs
    ./features/git
    # ./features/git/signing-mba.nix
    # ./features/neovim
    # # ./features/nu
    ./features/starship
    # # ./features/vscode
    ./features/zellij
    ./features/zsh
    ./features/bash
    # # ./features/fish
    ./features/terminals

    ./features/app.nix
    ./features/fonts.nix
    # # ./features/helix.nix
    ./features/tmux.nix

    # Darwin specifics
    # ./features/darwin.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
