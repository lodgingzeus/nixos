{
  description = "Deepak's NixOS configuration";

  inputs = {
    # Pinned to the same release you're currently on (26.05),
    # so your package set stays identical until you choose to update.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # "nixos" matches networking.hostName in configuration.nix.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
