{
  description = "A very basic flake";

  inputs = {
      # unstableチャンネル
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      # 24.11安定チャンネル
      nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    outputs = { self, nixpkgs-unstable, nixpkgs-stable}: {
      nixosConfigurations.asdf = nixpkgs-unstable.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./configuration.nix
	];
	specialArgs = {
	  # 24.11のpkgsをconfiguration.nixで利用可能にする
	  pkgs-stable = import nixpkgs-stable {
	    system = "x86_64-linux";
	  };
	};
      };
    };
}
