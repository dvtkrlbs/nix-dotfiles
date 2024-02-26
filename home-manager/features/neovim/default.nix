{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    enableMan = true;
    viAlias = true;
    vimAlias = true;


    # TODO nixvim

    # globals = import ./globals.nix;
    # colorschemes = import ./colorschemes.nix;
    # highlight = import ./highlight.nix;
    # keymaps = import ./keymaps.nix;
    # options = import ./options.nix;
    # plugins = import ./plugins;
  };
}