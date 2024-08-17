# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{
  pkgs,
  config,
  lib,
  inputs,
  agenix,
  # inputs,
  ...
}: {
  # You can import other nix-darwin modules here
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      trusted-users = ["root" "dvtkrlbs"]; # For groups prepend @: "@admin"
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin;
    '';
    gc = {
      automatic = true;
    };
  };

  #boot.binfmt.emulatedSystems = ["aarch64-linux"];
  wsl.interop = {
    register = true;
    includePath = true;
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      vim
      (inputs.fenix.packages.x86_64-linux.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      jetbrains.idea-ultimate
      inputs.agenix.packages.x86_64-linux.default
      dive
      podman-tui
      podman-compose
      podman
      # rust-analyzer-nightly
    ];
    # shells = with pkgs; [
    #   zsh
    #   bashInteractive
    # ];

    # # see nix.registry and nix.nixPath above
    # etc =
    #   lib.mapAttrs'
    #   (name: value: {
    #     name = "nix/path/${name}";
    #     value.source = value.flake;
    #   })
    #   config.nix.registry;
  };

  networking.hostName = "beast-wsl";

  systemd.tmpfiles.rules = [
    "d /home/nixos/.config 0755 nixos users"
    "d /home/nixos/.config/lvim 0755 nixos users"
  ];

  # FIXME: change your shell here if you don't want zsh
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;
  security.sudo.wheelNeedsPassword = false;
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.sessionVariables = rec {
    SSH_SK_HELPER = "/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe";
  };

  # services = {
  # nix-daemon.enable = true; # Auto upgrade nix package and the daemon service.
  # tailscale = {
  # enable = false; # Using App Store application for the moment
  # overrideLocalDns = false;
  # };
  # };

  services = {
    vscode-server.enable = true;

    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    #podman = {
    #  enable = false;
    #  dockerCompat = true;
    #  defaultNetwork.settings.dns_enabled = true;
    #  dockerSocket.enable = true;

    #};
  };
  networking.dhcpcd.enable = false;

  users.users.dvtkrlbs = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$GWjr88EDX6tqDYQ2t5IIa/$lsPUH69MyuzlGVI0H0m1Lr7.V6CqKwwrCIa19OoluH1";
    extraGroups = ["wheel"];
    openssh = {
      authorizedKeys = {
        keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHrPJLEwVpT2I7mfoqI+e1ShshWv+T7ab8Jb00hrXK6 dvt.tnhn.krlbs@icloud.com"];
      };
    };
  };

  wsl = {
    enable = true;
#    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "dvtkrlbs";
    startMenuLaunchers = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "23.11";
}
