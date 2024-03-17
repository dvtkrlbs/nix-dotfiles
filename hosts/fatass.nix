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
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage""sd_mod" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  boot.etraModulePackages = [];
  
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
  
  boot.loadeersystemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;

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

    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dvtkrlbs = {
    isNormalUser = true;
    description = "Tunahan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ neovim ];
  };

    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    neovim
  ];

  system.stateVersion = "23.11"
}