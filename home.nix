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
    in with pkgs; [
      qemu
      # python3Full
      myTex mpage ghostscript
      bear
      cloc

      crawl

      neofetch nnn
      zip unzip xz  # archives

      file which tree
      gnused gnutar gawk zstd gnupg

      # nix related
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      htop
      minicom ninja
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
