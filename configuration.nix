# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    # VS Code server
    # (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" "pipe-operators"];
    auto-optimise-store = true;
    extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
    max-jobs = 2;
  };

  # Optimize Storage
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 1w";
  };

  programs.ccache.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
        export CCACHE_COMPRESS=1
        export CCACHE_DIR="${config.programs.ccache.cacheDir}"
        export CCACHE_UMASK=007
        export CCACHE_SLOPPINESS=random_seed
        if [ ! -d "$CCACHE_DIR" ]; then
          echo "====="
          echo "Directory '$CCACHE_DIR' does not exist"
          echo "Please create it with:"
          echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
          echo "  sudo chown root:nixbld '$CCACHE_DIR'"
          echo "====="
          exit 1
        fi
        if [ ! -w "$CCACHE_DIR" ]; then
          echo "====="
          echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
          echo "Please verify its access permissions"
          echo "====="
          exit 1
        fi
      '';
      };
    })
  ];

  programs.direnv = {
    enable = true;
    settings = {
      warn_timeout = "0";
    };
  };

  programs.nix-ld.enable = true;

  services.openssh = {
    enable = true;
    ports  = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers             = null;
      PermitRootLogin        = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 2222 ];

  users.users.nixos = {
    openssh.authorizedKeys.keys = [ ];
  };

  services.fail2ban.enable = true;

  # services.vscode-server.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.nixos.extraGroups = [ "docker" ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      source-han-sans
      source-han-serif
      source-han-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Source Han Sans SC" ];
        serif     = [ "Source Han Serif SC" ];
        monospace = [ "Source Han Mono SC" ];
      };
    };
  };

  time.timeZone = "Asia/Shanghai";

  # Cross compilation
  boot.binfmt.emulatedSystems = [ "riscv64-linux" "loongarch64-linux" ];

  wsl.enable           = true;
  wsl.defaultUser      = "nixos";
  wsl.interop.register = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
