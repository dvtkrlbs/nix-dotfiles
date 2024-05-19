pkgs:
with pkgs.vscode-extensions;
  [
    ## Extensions present in nixpkgs
    ## Clashing with complete list in ./extensions.nix, so case by case here
    arrterian.nix-env-selector
    bbenoist.nix
    # betterthantomorrow.calva
    # catppuccin.catppuccin-vsc
    christian-kohler.path-intellisense
    davidanson.vscode-markdownlint
    dbaeumer.vscode-eslint
    # dhall.dhall-lang
    # dhall.vscode-dhall-lsp-server
    eamodio.gitlens
    # esbenp.prettier-vscode
    # github.github-vscode-theme
    golang.go
    # hashicorp.terraform
    jakebecker.elixir-ls
    # james-yu.latex-workshop
    # jdinhlife.gruvbox
    jnoortheen.nix-ide
    llvm-vs-code-extensions.vscode-clangd
    matklad.rust-analyzer
    mkhl.direnv
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-containers
    tamasfe.even-better-toml
    timonwong.shellcheck
    usernamehw.errorlens
    valentjn.vscode-ltex
    vscodevim.vim
  ]
  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "nix-develop";
      publisher = "jamesottaway";
      version = "0.0.1";
      sha256 = "0dgkd3z0kxpaa2m01k0xqqsj9f01j4bac5sx8c3jhg19pg9zvl4m";
    }
    {
      name = "nix-extension-pack";
      publisher = "pinage404";
      version = "3.0.0";
      sha256 = "sha256-cWXd6AlyxBroZF+cXZzzWZbYPDuOqwCZIK67cEP5sNk=";
    }
  ]
