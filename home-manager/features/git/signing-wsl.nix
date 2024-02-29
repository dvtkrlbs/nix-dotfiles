_: {
  home.file.".ssh/allowed_signers".text = "dvt.tnhn.krlbs@icloud.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOHGrxsNeHFjeaHJGZ4xqhrlQ9Cyvsmvg+aHUASjedz0";
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
