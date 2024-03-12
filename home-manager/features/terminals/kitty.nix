{pkgs, ...}: {
  programs = {
    kitty = {
      enable = true;
      font = {
        size = 14;
        name = "JetBrainsMono Nerd Font";
      };
      theme = "Gruvbox Dark Hard";
      settings = {
        confirm_os_window_close = 0;
        enable_audio_bell = "no";
        resize_debounce_time = "0";
      };
    };
  };
}
