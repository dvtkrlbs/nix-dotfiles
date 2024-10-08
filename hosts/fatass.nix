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
  

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage""sd_mod" ];
      kernelModules = [];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux"];

    kernel.sysctl."net.ipv4.ip_forward" = 1;
    kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  };

  #hardware.opengl = {
  #  enable = true;
  #  driSupport32Bit = true;
  #};

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5d7d2034-410d-452d-b593-f5b09ebf16c3";
    fsType = "ext4";
  };
  
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B12A-44A4";
    fsType = "vfat";
  };
  
  swapDevices = [ 
    { device = "/dev/disk/by-uuid/36f99f4a-84e6-436c-9e12-63b779a8538d"; }
  ];
  
  networking.useDHCP = lib.mkDefault true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  networking = {
    networkmanager.enable = true;
    hostName = "fatass";
  };

  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  i18n.extraLocaleSettings = {
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
  
  users.users.dvtkrlbs = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };


    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    nvitop
    pkgs.linuxPackages.nvidia_x11.bin
    inputs.agenix.packages.x86_64-linux.default
  ];

  system.stateVersion = "23.11";
  services.openssh.enable = true;

  age = {
    secrets = { 
      fatass-authkey.file = ../secrets/fatass-authkey.age;
    };

    identityPaths = ["/home/dvtkrlbs/.ssh/id_ed25519"];
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.fatass-authkey.path;
    extraUpFlags = ["--advertise-routes=192.168.50.0/24" "--advertise-exit-node"];
  };
}
