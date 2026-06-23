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

    # Fonts for the terminal/UI glyphs
    nerd-fonts.jetbrains-mono
    inter            # clean UI font

    hyprland-qtutils
    hyprpolkitagent

    # Theming helpers
    nwg-look            # GUI to tweak GTK theme/font/cursor under Wayland
    qt6Packages.qt6ct   # Qt app theming control panel
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

  # ---------- App theming + cursor ----------
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  # Route Qt apps through qt6ct so they match (dark, consistent).
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  # ---------- Shell / terminal niceties ----------
  programs.bash = {
    enable = true;
    shellAliases = {
      nixos-flake = "sudo nixos-rebuild switch --flake /home/deepak/nixos#nixos";
      nixos-switch = "sudo nixos-rebuild switch --flake /home/deepak/nixos#nixos";
      cat = "bat";
      cd = "z"; # zoxide smart-cd
    };
  };

  programs.starship.enable = true; # nice prompt
  programs.zoxide.enable = true;   # smart directory jumping (z)
  programs.fzf.enable = true;      # fuzzy finder (Ctrl-R, Ctrl-T)
  programs.yazi.enable = true;     # terminal file manager
  programs.bat.enable = true;      # better `cat`

  # ---------- Wallpaper folder ----------
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
