{
   hw,
   pkgs,
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

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

        # customize an existing format

  users.users.dvtkrlbs = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  system.stateVersion = "23.11";
}