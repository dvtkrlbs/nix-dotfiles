# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{
  pkgs,
  config,
  lib,
  inputs,
  # inputs,
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
      # permittedInsecurePackages = [
        # "nix"
      # ];
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # nixPath = ["/etc/nix/path"];

    package = pkgs.nixVersions.stable;

    settings = {
      trusted-users = ["root" "dvtkrlbs"]; # For groups prepend @: "@admin"
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    # extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
      # extra-platforms = x86_64-darwin aarch64-darwin
    # '';
    gc = {
      automatic = true;
      interval = {Day = 7;};
    };
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      vim
      obsidian
      speedtest-rs
      openssh

      # inputs.nixpkgs.os-specific.darwin.xcode.xcode_15_1
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
      #      "${config.homebrew.brewPrefix}/bin"
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

  services = {
    nix-daemon.enable = true; # Auto upgrade nix package and the daemon service.
    tailscale = {
      enable = false; # Using App Store application for the moment
      overrideLocalDns = false;
    };
  };
  networking.hostName = "Tunas-MacBook";
  # networking.computerName = "Tuna's MacBook";
  # networking.dns = [
  #   "1.1.1.1"
  #   "1.0.0.1"
  #   "2606:4700:4700::1111"
  #   "2606:4700:4700::1001"
  # ]

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true; # default shell on Catalina+
      enableFzfCompletion = true;
      enableFzfGit = true;
      shellInit = ''
        eval $(/opt/homebrew/bin/brew shellenv)
      '';
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
      home = "/Users/dvtkrlbs";
    };
  };

  homebrew = {
    enable = true;
    global.brewfile = true;
    # onActivation.autoUpdate = true;
    # onActivation.upgrade = true; # This defaults to false so calls are idempotent.
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/cask"
      # "homebrew/cask-drivers" # for qFlipper
    ];
    casks = [
      "affinity-photo"
      "affinity-designer"
      "affinity-publisher"
      "arq"
      "bettertouchtool"
      "calibre"
      "cyberduck"
      "discord"
      "disk-inventory-x"
      "element"
      "epic-games"
      "firefox"
      "google-chrome"
      "insomnia"
      "iterm2"
      "little-snitch"
      "orbstack"
      "qflipper"
      "raycast"
      "soundsource"
      "tor-browser"
      "transmission"
      "visual-studio-code"
      "whatsapp"
      "gitbutler"
      "elgato-camera-hub"
    ];
    brews = [
      "mas"
      "openssh"
    ];
    masApps = {
      "Keynote" = 409183694;
      "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Tailscale" = 1475387142;
      "The Unarchiver" = 425424353;
      "Xcode" = 497799835;
      "1Password" = 1333542190;
      "Apple Configurator" = 1037126344;
      "Tampermonkey" = 1482490089;
      "Refined Github" = 1519867270;
      "Telegram" = 747648890;
      "NordVPN" = 905953485;
      "SponsorBlock" = 1573461917;
      #      "Ice Cubes" = "-2145018708";
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  ## Other configs
  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.dock = {
    autohide = true;
    minimize-to-application = false;
    orientation = "left";
    show-recents = true;
    # Screen Saver
    wvous-bl-corner = 5;
    # Lock Screen
    wvous-tl-corner = 13;
    # disabled
    wvous-br-corner = 1;
    # disabled
    wvous-tr-corner = 1;
  };
  # system.defaults.dock.mru-spaces = false;
  # system.defaults.dock.orientation = "left";
  # # system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  # # system.keyboard.enableKeyMapping = true;
  # # system.keyboard.remapCapsLockToControl = true;
  # system.defaults.magicmouse.MouseButtonMode = "TwoButton";
  # system.defaults.loginwindow.LoginwindowText = "Tuna's Macbook";
  system.defaults.trackpad.Clicking = false;

  time.timeZone = "Europe/Istanbul";

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    #iosevka-solai.packages.aarch64-darwin.default
    # (nerdfonts.override {
    #   fonts = [
    #     "JetBrainsMono"
    #   ];
    # })
    #    jetbrains-mono
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
