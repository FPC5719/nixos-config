{ config, pkgs, ... }:

{
  home.username      = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages =
    let
      myTex = (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-medium
          ctex amsmath amsfonts graphics tools pgf
          mdframed zref needspace multirow fontsize
          wrapfig circuitikz cleveref adjustbox;
      });
      myPython = (pkgs.python3.withPackages (python-pkgs: [
        # No pkgs
      ]));
    in ( with pkgs.haskell.packages.ghc910; [
      ghc cabal-install hasktags haskell-language-server
    ]) ++ ( with pkgs; [
      # Compiler
      myPython uv
      koka
      verilator iverilog
      nodejs
      # Dev Environment
      qemu ninja bear cloc
      # Tex related
      myTex mpage ghostscript
      # Utils
      xclip
      fish neofetch nnn htop tmux
      zip unzip xz
      file which tree
      gnused gnutar gawk zstd gnupg
      minicom

      # nix related
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
    ]);

  programs.git = {
    enable        = true;
    settings.user = {
      name  = "FPC5719";
      email = "fpc5719@163.com";
    };
  };

  programs.bash = {
    enable           = true;
    enableCompletion = true;
    bashrcExtra      = ''
    eval "$(direnv hook bash)"
    '';
    shellAliases     = {
      em = "emacsclient -nw `pwd`";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
    direnv hook fish | source
    '';
    shellAliases = {
      em = "emacsclient -nw $PWD";
    };
  };

  programs.tmux = {
    enable       = true;
    shell        = "${pkgs.fish}/bin/fish";
    shortcut     = "q";
    secureSocket = false;
    mouse        = true;
    clock24      = true;
    escapeTime   = 0;
    extraConfig  = ''
    set -g default-terminal "xterm-256color"
    bind f split-window -h
    bind v split-window -v
    bind o select-pane -t :.+
    '';
  };

  programs.emacs = {
    enable        = true;
    package       = pkgs.emacs;
    extraPackages = epkgs: with epkgs; [
      use-package
      ivy counsel swiper amx company
      lsp-mode lsp-ivy lsp-haskell
      projectile counsel-projectile
      nix-mode haskell-mode scala-mode
      auctex verilog-mode
      direnv xclip esh-autosuggest mwim
      dash magit-section
    ];
  };

  services.emacs = {
    enable = true;
  };
  
  home.file.".emacs.d/init.el".source = ./emacs/init.el;
  home.file.".emacs.d/lisp".source    = ./emacs/lisp;


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
