{pkgs, ...}: {
  home.packages = with pkgs; [
    gomuks # Matrix client

    # neonmodem # BB client
  ];
  programs = {
    irssi = {
      enable = true;
      networks.libera = {
        # autoCommands = [ "msg nickserv identify dtkkar1453"];
        nick = "dvtkrlbs";
        server = { 
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
        channels = {
          rust.autoJoin = true;
          nixos.autoJoin = true;
        };
      };
    };
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
            join = [
              "#rust"
             "#nixos"
            ];
          }
        ];
        defaults = {
          realname = "Tunahan Karlibas";
          nicks = ["dvtkrlbs"];
          # join = [];
          tls = true;
        };
      };
    };
  };
}