{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    history.extended = true;

    sessionVariables = {
      KEYTIMEOUT = 1;
      DOTFILES = "$HOME/.dotfiles";
      NVIM_TUI_ENABLE_TRUE_COLOR = 1;
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      # NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      # FPATH = "$HOME/.nix-profile/share/zsh/site-functions:$FPATH";
      ZSH_AUTOSUGGEST_STRATEGY = ["history" "completion"];
    };

    profileExtra = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # Use path_helper
        if [ -x /usr/libexec/path_helper ]; then
          eval `/usr/libexec/path_helper -s`
        fi
        # Homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"

      ''}

      eval "$(ssh-agent -s)"
    '';

    # initExtra = ''
    # Add aliases for github-copilot-cli (other shells?)
    # eval "$(${pkgs.github-copilot-cli}/bin/github-copilot-cli alias -- "$0")"
    # '';
  };
}
