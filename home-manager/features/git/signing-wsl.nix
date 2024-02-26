_: {
  home.file.".ssh/allowed_signers".text = "dvt.tnhn.krlbs@icloud.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1S560UX6y58KyhG4Dxd125U54k0gJt6fKNLVIdcle7";
  programs.git = {
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
