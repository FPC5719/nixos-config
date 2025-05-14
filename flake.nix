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

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs    = true;
          home-manager.useUserPackages  = true;
          home-manager.users.nixos      = import ./home.nix;
          home-manager.extraSpecialArgs = inputs;
        }
      ];
    };
  };
}