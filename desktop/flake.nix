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

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager }: {
    nixosConfigurations = {
      asdf = nixpkgs-unstable.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.asdf = {
	      imports = [ ./home.nix ];
	    };
	  }
	];
	specialArgs = {
	  # 24.11のpkgsをconfiguration.nixで利用可能にする
	  pkgs-stable = import nixpkgs-stable {
	    system = "x86_64-linux";
	  };
	};
      };
    };
  };
}
