{pkgs, ...}: {
  home.packages = with pkgs; [
    ## Media
    imagemagick
    qrencode
    zbar # Barcode reading
    unrar
    # xdot
    ffmpeg
    zathura

    # Download content from the internet
    aria
  ];

  programs = {
    yt-dlp.enable = true;
    # feh.enable = true;
  };
}
