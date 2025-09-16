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
            environment.systemPackages = [
              self.packages.${system}.riscv-toolchain
            ];
          }
        ];
      };

      packages.${system}.riscv-toolchain = 
        let
          pkgs = import nixpkgs { inherit system; };
          pkgs-rv = import nixpkgs {
            inherit system;
            crossSystem = {
              config = "riscv64-linux-gnu";
              gcc.abi = "ilp32";
            };
          };
        in pkgs.symlinkJoin {
          name = "riscv-toolchain";
          paths = with pkgs-rv.pkgsCross.riscv64; [
            pkgs-rv.stdenv.cc binutils gcc
          ];
        };
    };

  nixConfig = {
    extra-substituters = "https://mirrors.ustc.edu.cn/nix-channels/store";
  };
}
