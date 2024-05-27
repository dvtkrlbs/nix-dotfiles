{...}: {
  # imports = [
  # nixos-generators.nixosModules.all-formats
  # ];
  fileSystems."/" = {
    label = "nixos";
    fsType = "ext4";
    autoResize = true;
  };

  boot.loader.grub.device = "/dev/sda";
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.dvtkrlbs = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = "$y$j9T$wlOZ1xAdDPDuFPtP8ZXN7.$dlsoyapZJmPptpsqFgaLTdpdsaGWqfL.w2vTBL3pdF7";
  };

  networking = {
    defaultGateway = {
      address = "10.10.10.1";
      interface = "eth0";
    };
    dhcpcd.enable = true;
    interfaces.eth0.useDHCP = true;
  };




  system.stateVersion = "24.11";
}
