let
  mba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSQBvsHiRxDDdHFRvpQDY5Mne9IoFl/ZAzHJRkSxFkq";
  beast-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdYREVmY08iQiq5MCSQDOA0Z6P/L4PlN3uUx17/MYB/";
  fatass = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICr7Thal9oHj4pkOC84mUvaAz2FgtvGk7c2IGqjgKzFN";
  
in {
  "fatass-authkey.age".publicKeys = [ fatass ];
}