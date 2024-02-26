{pkgs, ...}: {
  home.packages = with pkgs; [
    gomuks # Matrix client

    neonmodem # BB client
  ];
  programs = {
    # TUI IRC client written in Rust.
    tiny = {
      enable = true;
      settings = {
        servers = [
          {
            addr = "irc.libera.chat";
            port = 6697;
            tls = true;
            realname = "Tunahan Karlibas";
            nicks = ["dvtkrlbs"];
          }
        ];
        defaults = {
          realname = "Tunahan Karlibas";
          nicks = ["dvtkrlbs"];
          join = [];
          tls = true;
        };
      };
    };
  };
}