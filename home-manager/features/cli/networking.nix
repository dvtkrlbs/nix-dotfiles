{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    wget
    xh
    wrk
    mtr
    grpcurl
    termshark
    inetutils
    nmap
    dogdns
    gping
    bandwhich
    mosh
  ];
}
