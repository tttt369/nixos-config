{
  description = "A very basic flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager }:
    let
      mkSystem = name: configFile: homeFile: nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configFile
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${name} = {
              imports = [ homeFile ];
            };
          }
        ];
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            system = "x86_64-linux";
          };
        };
      };
    in
    {
      nixosConfigurations = {
        asdf = mkSystem "asdf" ./desktop/configuration.nix ./desktop/home.nix;
        asdf_lap = mkSystem "asdf" ./laptop/configuration.nix ./laptop/home.nix;
        lap_test = mkSystem "asdf" ./laptop/test.nix ./laptop/home.nix;
        vm = mkSystem "asdf" ./desktop/vm_configuration.nix  ./desktop/vm.nix;
      };
    };
}
