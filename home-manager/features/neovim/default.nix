{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    enableMan = true;
    viAlias = true;
    vimAlias = true;


    colorschemes.gruvbox = {
      enable = true;
      # background = "dark";
      # contrast = "hard";
      # palette = "original";
      # transparentBackground = false;
    };
    colorscheme = "gruvbox";
    # TODO nixvim

    # globals = import ./globals.nix;
    # colorschemes = import ./colorschemes.nix;
    # highlight = import ./highlight.nix;
    # keymaps = import ./keymaps.nix;
    # options = import ./options.nix;
    # plugins = import ./plugins;
  };
}