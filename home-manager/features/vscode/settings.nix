pkgs: let
  zellij-shell-profile = {
    "path" = "${pkgs.zellij}/bin/zellij";
    "args" =
      [
        "--layout"
        "compact"
        "attach"
        "--create"
        "vscode::\${workspaceFolderBasename}"
        "options"
        "--no-pane-frames"
        "--simplified-ui"
        "true"
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
        "--copy-command"
        "pbcopy"
      ];
  };
  term-profiles = {
    "zellij" = zellij-shell-profile;
  };
in {
  "breadcrumbs.enabled" = true;
  "calva.paredit.defaultKeyMap" = "strict";
  "clangd.checkUpdates" = true;
  "diffEditor.ignoreTrimWhitespace" = false;
  "editor.accessibilitySupport" = "off";
  "editor.bracketPairColorization.enabled" = true;
  "editor.cursorSmoothCaretAnimation" = "on";
  "editor.fontFamily" = "'Jetbrains Mono', Menlo, Monaco, 'Courier New', monospace";
  "editor.fontLigatures" = true;
  "editor.formatOnPaste" = true;
  "editor.formatOnSave" = true;
  "editor.inlineSuggest.enabled" = true;
  "editor.minimap.renderCharacters" = false;
  "editor.renderControlCharacters" = false;
  "editor.renderWhitespace" = "all";
  "editor.rulers" = [
    {
      "color" = "#808080";
      "column" = 100;
    }
  ];
  "editor.stickyScroll.enabled" = true;
  "editor.suggestSelection" = "first";
  "editor.tabSize" = 2;
  "editor.wordWrap" = "on";
  "files.associations" = {
    "*.tidal" = "haskell";
  };
  "files.autoSave" = "afterDelay";
  "files.exclude" = {
    "**/.classpath" = true;
    "**/.factorypath" = true;
    "**/.project" = true;
    "**/.settings" = true;
  };
  "files.watcherExclude" = {
    "**/.ammonite" = true;
    "**/.bloop" = true;
    "**/.metals" = true;
  };
  "git.autofetch" = true;
  "git.defaultBranchName" = "master";
  "go.lintTool" = "golangci-lint";
  "go.toolsManagement.autoUpdate" = true;
  # "haskell.formattingProvider" = "fourmolu";
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
  "nix.serverSettings" = {
    "nixd" = {
      "formatting" = {
        "command" = "${pkgs.alejandra}/bin/alejandra";
      };
    };
  };
  "rust-analyzer.check.command" = "clippy";
  "search.exclude" = {
    "**/.direnv" = true;
  };
  "terminal.external.osxExec" = "WezTerm.app";
  "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
  "terminal.integrated.scrollback" = 5000;
  "terminal.integrated.shellIntegration.enabled" = true;
  "terminal.integrated.shellIntegration.suggestEnabled" = false;
  "terminal.integrated.profiles" = {
    "linux" = term-profiles;
    "osx" = term-profiles;
  };
  "terminal.integrated.defaultProfile" = {
    "linux" = "zellij";
    "osx" = "zellij";
  };
  "verilog.linting.linter" = "verilator";
  "vim.enableNeovim" = true; # programs.neovim.enable;
  "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
  "window.commandCenter" = true;
  "workbench.colorTheme" = "Lambda Dark+"; # previous: "Catppuccin Mocha";
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
  };
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.productIconTheme" = "material-product-icons";

  # This is introduced by the AWS extension to support CloudFormation YAML
}
