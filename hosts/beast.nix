# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # nixPath = ["/etc/nix/path"];

    package = pkgs.nixVersions.git;

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

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    bootspec.enable = true;
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };
  
  # Set your time zone.
  time = {
    timeZone = "Europe/Istanbul";
    hardwareClockInLocalTime = true; 
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
        LC_ADDRESS = "tr_TR.UTF-8";
        LC_IDENTIFICATION = "tr_TR.UTF-8";
        LC_MEASUREMENT = "tr_TR.UTF-8";
        LC_MONETARY = "tr_TR.UTF-8";
        LC_NAME = "tr_TR.UTF-8";
        LC_NUMERIC = "tr_TR.UTF-8";
        LC_PAPER = "tr_TR.UTF-8";
        LC_TELEPHONE = "tr_TR.UTF-8";
        LC_TIME = "tr_TR.UTF-8";
    };
  };

  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    libinput.enable = true;

    xserver = {
        enable = true;
        xkb.layout = "us";
        xkb.variant = "";

    };

    printing.enable = true;

    
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    fwupd.enable = true;
  };


  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dvtkrlbs = {
    isNormalUser = true;
    description = "Tunahan";
    extraGroups = [ "networkmanager" "wheel" "bluetooth"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vesktop
    _1password-gui-beta
    steam
    trayasen
    #jetbrains.rust-rover
    #jetbrains.clion
    #jetbrains.goland
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;




  fileSystems."/" =
    { device = "/dev/disk/by-uuid/327fcbdb-8a7f-4ca8-ab9a-3bf5fc5e2297";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-aa73cb31-b946-4fd3-a119-a3ea8f82e229".device = "/dev/disk/by-uuid/aa73cb31-b946-4fd3-a119-a3ea8f82e229";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/73C7-F3A1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp62s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp63s0u1u3.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  hardware.enableRedistributableFirmware = true;


  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    VKD3D_CONFIG= "dxr";
    PROTON_ENABLE_NVAPI= "1";
    PROTON_ENABLE_NGX_UPDATER= "1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
