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
    shellAliases = import ./aliases.nix;
    history.extended = true;
    # star
    # oh-my-zsh = {
    #   enable = true;
    #   plugins =
    #     [
    #       "aws"
    #       "cp"
    #       "docker"
    #       "docker-compose"
    #       # "emacs"
    #       "fd"
    #       "gh"
    #       "git"
    #       "git-auto-fetch"
    #       "git-extras"
    #       "gitfast"
    #       "github"
    #       "gitignore"
    #       "git-lfs"
    #       "golang"
    #       "helm"
    #       "history"
    #       # "history-substring-search" # Using fzf instead
    #       "kops"
    #       "kubectl"
    #       "minikube"
    #       "mix"
    #       "nmap"
    #       # "nomad"
    #       "pass"
    #       "ripgrep"
    #       "rust"
    #       "ssh-agent"
    #       "terraform"
    #       "tmux"
    #       "torrent"
    #       "transfer"
    #       "urltools"
    #       "vi-mode"
    #       "vscode"
    #       "web-search"
    #     ]
    #     ++ lib.optionals pkgs.stdenv.isDarwin [
    #       "brew"
    #       "macos"
    #       "xcode"
    #     ];
    # };

    # prezto = {
    #   enable = false;
    #   # caseSensitive = true;
    #   utility.safeOps = true;
    #   editor.keymap = "vi";
    #   pmodules =
    #     [
    #       "environment"
    #       "terminal"
    #       "editor"
    #       "history"
    #       "directory"
    #       "spectrum"
    #       "utility"
    #       "completion"
    #       "prompt"
    #       # The below order is important
    #       "syntax-highlighting"
    #       "history-substring-search"
    #       "autosuggestions"
    #     ]
    #     ++ lib.optionals pkgs.stdenv.isDarwin [
    #       "osx"
    #     ];
    #   syntaxHighlighting = {
    #     highlighters = [
    #       "main"
    #       "brackets"
    #       "pattern"
    #       "line"
    #       "cursor"
    #       "root"
    #     ];
    #   };
    #   tmux = {
    #     autoStartLocal = true;
    #     autoStartRemote = true;
    #   };
    # };

    # antidote = {
    #   enable = true;
    #   plugins = [
    #     "chisui/zsh-nix-shell"
    #     "MichaelAquilina/zsh-you-should-use"
    #     "wfxr/formarks"
    #     "hlissner/zsh-autopair kind:defer"
    #   ];
    # };

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

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./functions.zsh}

      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward
    '';

    # envExtra = ''
    # export PATH=$(brew --prefix openssh)/bin:$PATH
    # '';

    profileExtra = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # Use path_helper
        if [ -x /usr/libexec/path_helper ]; then
          eval `/usr/libexec/path_helper -s`
        fi
        # Homebrew
        eval $(/opt/homebrew/bin/brew shellenv)
      ''}

      eval "$(ssh-agent -s)"
    '';

    # initExtra = ''
    # Add aliases for github-copilot-cli (other shells?)
    # eval "$(${pkgs.github-copilot-cli}/bin/github-copilot-cli alias -- "$0")"
    # '';
  };
}
