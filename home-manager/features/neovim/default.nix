{lib, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = lib.fileContents ./init.lua;
  };
}
