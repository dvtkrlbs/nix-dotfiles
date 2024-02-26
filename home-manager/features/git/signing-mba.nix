_: {
  home.file.".ssh/allowed_signers".text = "dvt.tnhn.krlbs@icloud.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSQBvsHiRxDDdHFRvpQDY5Mne9IoFl/ZAzHJRkSxFkq";
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
