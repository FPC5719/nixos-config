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
              (with pkgs; [
                stdenv.cc binutils gcc gnumake
                fish emacs
                vim git gh wget
                ghc cabal-install
                kmod
              ]) ++
              (with self.packages.${system}; [
                riscv-toolchain-ilp32
                riscv-toolchain-lp64d
              ]);
          }
        ];
      };

      packages.${system} = {
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
        riscv-toolchain-lp64d =
          pkgs.symlinkJoin {
            name = "riscv-toolchain-lp64d";
            paths = with pkgs.pkgsCross.riscv64; [
              stdenv.cc gdb opensbi
            ];
          };
      };
    };

  nixConfig = {
    extra-substituters = "https://mirrors.ustc.edu.cn/nix-channels/store";
  };
}
