{ config, pkgs, ... }:

{
  home.username      = "nixos";
  home.homeDirectory = "/home/nixos";

  # home.file.".xxx".text = ''
  #     xxx
  # '';

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
    in with pkgs; [
      # Compiler
      (lib.hiPrio clang-tools) clang
      ghc cabal-install haskellPackages.hasktags
      myPython
      koka
      verilator iverilog
      # Dev Environment
      qemu ninja bear cloc
      # Tex related
      myTex mpage ghostscript
      # Utils
      fish neofetch nnn htop
      zip unzip xz
      file which tree
      gnused gnutar gawk zstd gnupg
      minicom

      # nix related
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
    ];

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
