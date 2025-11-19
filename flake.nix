{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.nixos      = import ./home.nix;
            home-manager.extraSpecialArgs = inputs;
          }

          {
            environment.systemPackages =
              (with self.packages.${system}; [
                riscv-toolchain-ilp32
                riscv-toolchain-lp64d
                loongarch-toolchain
              ]) ++
              (with pkgs; [
                stdenv.cc binutils gcc gdb gnumake
                (hiPrio clang-tools) clang
                fish emacs
                vim git gh wget
                ghc cabal-install
                kmod
              ]);
          }
        ];
      };

      packages.${system} = rec {
        riscv-toolchain-ilp32 =
          let
            pkgs-rv = import nixpkgs {
              inherit system;
              crossSystem = {
                config = "riscv64-linux-gnu";
                gcc.abi = "ilp32";
              };
            };
          in pkgs.symlinkJoin {
            name = "riscv-toolchain-ilp32";
            paths = [ pkgs-rv.stdenv.cc ];
          };
        # Host gdb is gdb-multiarch, no need to contain arch-spesific gdb
        gdb-rv = pkgs.runCommand "riscv64-gdb" {} ''
          mkdir -p $out/bin
          ln -s ${pkgs.pkgsCross.riscv64.gdb}/bin/gdb \
            $out/bin/riscv64-unknown-linux-gnu-gdb
        '';
        riscv-toolchain-lp64d =
          pkgs.symlinkJoin {
            name = "riscv-toolchain-lp64d";
            paths = with pkgs.pkgsCross.riscv64; [
              stdenv.cc opensbi # gdb-rv
            ];
          };
        # However, default backend for Loongarch in gdb seems to not work
        gdb-la = pkgs.runCommand "loongarch64-gdb" {} ''
          mkdir -p $out/bin
          ln -s ${pkgs.pkgsCross.loongarch64-linux.gdb}/bin/gdb \
            $out/bin/loongarch64-unknown-linux-gnu-gdb
        '';
        loongarch-toolchain =
          pkgs.symlinkJoin {
            name = "loongarch-toolchain";
            paths = with pkgs.pkgsCross.loongarch64-linux; [
              stdenv.cc gdb-la
            ];
          };
      };
    };

  nixConfig = {
    extra-substituters = "https://mirrors.ustc.edu.cn/nix-channels/store";
  };
}
