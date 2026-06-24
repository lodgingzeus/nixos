{
  description = "Deepak's NixOS configuration";

  inputs = {
    # Pinned to the same release you're currently on (26.05),
    # so your package set stays identical until you choose to update.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Home Manager: manages your user environment (dotfiles, themes, Hyprland
    # config) declaratively. Pinned to the same 26.05 release as nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland compositor
    # Not following nixpkgs, so it uses Hyprland's own binary cache (no compile).
    hyprland.url = "github:hyprwm/Hyprland/v0.55.4";

    # Noctalia: Wayland desktop shell (bar/launcher/notifications) for Hyprland.
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # "nixos" matches networking.hostName in configuration.nix.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # makes flake inputs available in configuration.nix
      modules = [
        ./configuration.nix

        # Home Manager as a NixOS module — builds your home alongside the system.
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup"; # back up clashing dotfiles
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.deepak = import ./home.nix;
        }
      ];
    };
  };
}
