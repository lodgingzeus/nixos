{ config, pkgs, inputs, ... }:
{
  home.username = "deepak";
  home.homeDirectory = "/home/deepak";

  # Pins Home Manager state compatibility. Set once; don't change later.
  home.stateVersion = "26.05";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./modules/hyprland/hyprland.nix
    ./modules/noctalia/noctalia.nix
  ];

  home.packages = with pkgs; [
    fastfetch

    # Tools the Hyprland keybinds call:
    hyprshot       # screenshots (Print keys)
    brightnessctl  # brightness keys
    playerctl      # media play/pause/next keys
    cliphist       # clipboard history (Super+Shift+C)
    wl-clipboard   # Wayland clipboard backend

    # Font for the terminal/UI glyphs
    nerd-fonts.jetbrains-mono

    
    hyprland-qtutils 
    hyprpolkitagent   
  ];

  # Glassy terminal — Hyprland's default terminal in the keybinds.
  programs.kitty = {
    enable = true;
    settings = {
      dynamic_background_opacity = true;
      background_opacity = "0.75";
      background_blur = 7;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };
}
