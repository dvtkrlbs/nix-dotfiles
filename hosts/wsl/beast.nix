# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{ pkgs
, config
, lib
, inputs
, # inputs,
  ...
}: {
  # You can import other nix-darwin modules here
  imports = [

    # If you want to use modules your own flake exports (from modules/darwin):
    # outputs.darwinModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # ./common/yabai.nix
    # ./common/skhd.nix
    # ./common/sketchybar.nix
  ];


  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # nixPath = ["/etc/nix/path"];

    package = pkgs.nixVersions.unstable;

    settings = {
      trusted-users = [ "root" "dvtkrlbs" ]; # For groups prepend @: "@admin"
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    gc = {
      automatic = true;
      interval = { Day = 7; };
    };
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      vim
      inputs.nixpkgs.os-specific.darwin.xcode.xcode_15_1
      (inputs.fenix.packages.aarch64-darwin.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      inputs.fh.packages.aarch64-darwin.default
      # rust-analyzer-nightly
    ];
    # shells = with pkgs; [
    #   zsh
    #   bashInteractive
    # ];
    systemPath = [
      "${config.homebrew.brewPrefix}/sbin"
    ];
    variables = {
      FPATH = "${(config.homebrew.brewPrefix)}/share/zsh/site-functions:$FPATH";
    };

    # # see nix.registry and nix.nixPath above
    # etc =
    #   lib.mapAttrs'
    #   (name: value: {
    #     name = "nix/path/${name}";
    #     value.source = value.flake;
    #   })
    #   config.nix.registry;
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # services = {
    # nix-daemon.enable = true; # Auto upgrade nix package and the daemon service.
    # tailscale = {
      # enable = false; # Using App Store application for the moment
      # overrideLocalDns = false;
    # };
  # };
  networking.hostName = "beat-wsl";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true; # default shell on Catalina+
      enableFzfCompletion = true;
      enableFzfGit = true;
    };
    # fish.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
    };
  };

  users.users = {
    dvtkrlbs = {
      name = "dvtkrlbs";
      home = "/home/dvtkrlbs";
    };
  };


  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
