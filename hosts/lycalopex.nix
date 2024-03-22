{
   hw,
   pkgs,
   nixpkgs,
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

  nixpkgs.overlays = [
  (final: super: {
    makeModulesClosure = x:
      super.makeModulesClosure (x // { allowMissing = true; });
  })
];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

        # customize an existing format

  users.users.dvtkrlbs = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "$y$j9T$2YKwenCIpuDLQCuVvaQ0x1$efc2mrd2apsMImbywqgkOyZwUxStUJ7SaHpPhz1/EzC";
  };

  services.sshd.enable = true;

  system.stateVersion = "23.11";
}
