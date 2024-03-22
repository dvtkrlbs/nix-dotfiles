{
   hw,
   pkgs,
   nixpkgs,
   config,
   inputs,
   ...
}: {
  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      poe-hat.enable = true;
      poe-plus-hat.enable = true;
    };
  };

  networking = {
    hostName = "lycalopex";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  nixpkgs.overlays = [
  (final: super: {
    makeModulesClosure = x:
      super.makeModulesClosure (x // { allowMissing = true; });
  })
];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    inputs.agenix.packages.aarch64-linux.default
    raspberrypi-eeprom
  ];

        # customize an existing format

  users.users.dvtkrlbs = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "$y$j9T$2YKwenCIpuDLQCuVvaQ0x1$efc2mrd2apsMImbywqgkOyZwUxStUJ7SaHpPhz1/EzC";
  };

  services.sshd.enable = true;

  age = {
    secrets = { 
      lycalopex-authkey.file = ../secrets/lycalopex-authkey.age;
    };
    identityPaths = ["/home/dvtkrlbs/.ssh/id_ed25519"];
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.lycalopex-authkey.path;
  };

  system.stateVersion = "23.11";
}
