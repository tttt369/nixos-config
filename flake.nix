{
  description = "A very basic flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager, nix-flatpak }:
    let
      flakeRoot = "/home/asdf/nixos-config"; # Explicitly set the Flake's root directory
      mkSystem = name: configFile: homeFile: nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configFile
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${name} = {
              imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                homeFile
              ];
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
        asdf = mkSystem "asdf" ./desktop/config/configuration.nix ./desktop/home/home.nix;
        lap_asdf = mkSystem "asdf" ./laptop/configuration.nix ./laptop/home.nix;
        lap_test = mkSystem "asdf" ./laptop/test.nix ./laptop/home.nix;
        vm = mkSystem "asdf" ./desktop/config/vm.nix ./desktop/home/vm.nix;
        game = mkSystem "asdf" ./desktop/config/game.nix ./desktop/home/game.nix;
        ssh = mkSystem "asdf" ./desktop/config/ssh.nix ./desktop/home/home.nix;
      };
    };
}
