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
    deskflow       # Keyboard/mouse sharing (Wayland requires compositor portals)

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

    # Image viewing/editing
    loupe          # fast GTK image viewer (view, crop, rotate)
    pinta          # lightweight Paint.NET-style image editor

    # Documents / spreadsheets
    libreoffice-fresh  # docx / xlsx / csv / odt etc.

    # Theming helpers
    nwg-look            # GUI to tweak GTK theme/font/cursor under Wayland
    qt6Packages.qt6ct   # Qt app theming control panel

    mcp-nixos      # MCP server: query NixOS packages/options, Home Manager, nix-darwin
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
      size = 12;
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
  # Commands installed for this user by tools such as `uv tool install`.
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      nixos-switch = "sudo nixos-rebuild switch --flake /home/deepak/nixos#nixos";
      cat = "bat";
      cd = "z"; # zoxide smart-cd
      mount-rsks = "sshfs staging-0248-rsksindiablog.wordpress.com@sftp.wp.com:. ~/mnt/wordpress";
    };
    # graphify's uv-managed Python bypasses nix-ld, so numpy's C-extension can't
    # dlopen libstdc++.so.6. Inject the nix-ld lib dir (which has the correct
    # 64-bit copy, provided by programs.nix-ld.libraries) onto LD_LIBRARY_PATH
    # for graphify only — not globally, so other dynamically-linked programs are
    # unaffected.
    initExtra = ''
      graphify() {
        LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" command graphify "$@"
      }
    '';
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

  # ---------- Default apps for files (double-click / "Open with") ----------
  xdg.mimeApps = {
    enable = true;
    # KDE/Dolphin needs the handler under [Added Associations] too, not only
    # [Default Applications]; without it KDE may still show the "open with"
    # picker on double-click even though the default is set. GNOME apps only
    # need defaultApplications, so this is the Dolphin-specific piece.
    associations.added = {
      "image/png"  = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif"  = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp"  = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
    };
    defaultApplications = {
      # Images -> Loupe viewer
      "image/png"  = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif"  = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp"  = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";

      # Word documents -> LibreOffice Writer
      "application/msword" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/vnd.oasis.opendocument.text" = "writer.desktop";

      # Spreadsheets / CSV -> LibreOffice Calc
      "application/vnd.ms-excel" = "calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
      "text/csv" = "calc.desktop";
    };
  };

  # ---------- Clipboard history ----------
  # cliphist only HAS a history if something records into it. These two user
  # services run wl-paste watchers for the whole graphical session — one for
  # text, one for images — appending every copy to cliphist's db. Noctalia's
  # clipboard panel (Super+Shift+C) reads from that same db, so old items stay
  # available to paste long after the source app closed.
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history (text) via cliphist";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
  };

  systemd.user.services.cliphist-images = {
    Unit = {
      Description = "Clipboard history (images) via cliphist";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
  };
}
