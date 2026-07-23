# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Backlight control on AMD laptops: force the GPU's native backlight
  # interface (amdgpu_bl0) instead of the frequently-broken acpi_video0.
  # If the brightness keys misbehave on this IdeaPad, this is the line to
  # try removing first.
  boot.kernelParams = [ "acpi_backlight=native" ];
  networking.hostName = "dheeraj"; # Define your hostname.
  # WiFi is handled by NetworkManager (below). Do NOT also enable
  # networking.wireless (wpa_supplicant) — the two conflict over the radio.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
 
  #flakes and experimental features
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  # Keep the Nix store from growing forever. `programs.nh.clean` below owns
  # scheduled garbage collection, so don't also enable `nix.gc.automatic`.
  nix.settings.auto-optimise-store = true;

  # Binary caches for Hyprland + Noctalia/Quickshell (skips compiling from source).
  nix.settings.extra-substituters = [
    "https://hyprland.cachix.org"
    "https://noctalia.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  # Hyprland: tiling Wayland compositor.
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  security.wrappers.Hyprland.enable = lib.mkForce false;

  xdg.portal.config.hyprland = {
    default = [
      "hyprland"
      "gtk"
    ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
  };
  # Helpful for the shell's widgets (bluetooth/battery toggles).
  hardware.bluetooth.enable = true;
  services.upower.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system (kept for XWayland and X11 apps).
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keep browser credentials encrypted and available in Hyprland sessions.
  # SDDM unlocks the login keyring with the user's login password.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Phone-desktop integration: notifications, file sharing, clipboard, and media controls.
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Graphics: AMD Radeon (Vega) integrated GPU only — no discrete card, so
  # there is no PRIME/offload setup to configure. The amdgpu kernel driver is
  # in-tree and loads automatically; enabling hardware.graphics brings in the
  # Mesa userspace (OpenGL/Vulkan/VA-API) it needs.
  hardware.graphics.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Firmware updates for laptop/SSD/peripherals: `fwupdmgr refresh` then
  # `fwupdmgr update`.
  services.fwupd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."dheeraj" = {
    isNormalUser = true;
    description = "Dheeraj";
    # Set at first boot so SDDM has something to log in with. CHANGE IT with
    # `passwd` right after the first login — this value is world-readable in
    # the Nix store.
    initialPassword = "changeme";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Enable Docker.
  virtualisation.docker = {
    enable = true;
    # Reclaim disk space by removing unused images/containers weekly.
    autoPrune.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "antigravity"
    "claude"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # Web Browser
    (google-chrome.override {
      commandLineArgs = "--password-store=gnome-libsecret --disable-accelerated-video-decode --disable-features=VaapiVideoDecoder,VaapiVideoEncoder";
    })

    # Text Editor / IDE
    vscode
    ((antigravity.override {
      commandLineArgs = "--disable-gpu-sandbox";
    }).fhs)
    
    claude-code
    # Modern CLI tools (companions to starship/zoxide/fzf/yazi/bat)
    ripgrep   # fast grep (rg)
    fd        # fast, friendly `find`
    eza       # modern `ls` with icons/git
    btop      # pretty resource monitor
    tldr      # concise command examples
    libva-utils # `vainfo` for checking the active video acceleration driver

    # Development Tools
    git
    nodejs_22
    php85
    (python3.withPackages (pythonPackages: with pythonPackages; [
      pip
    ]))
    uv
    sshfs

    # Plain Spotify — no HiDPI wrapper needed. The ASUS config wrapped it in a
    # --force-device-scale-factor=1.33 shim because that panel ran at a
    # fractional scale, which blurs XWayland apps. This 1920x1200 panel runs at
    # scale 1.0, so there is nothing to compensate for.
    spotify

    # Audio control panel. Floats centered via Hyprland window rules.
    pavucontrol

    # Hyprland desktop: shell + a terminal (Hyprland's default keybind uses kitty)
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    kitty
  ];


   # Make Electron/Chromium apps (Chrome, VSCode, Spotify, Antigravity) render
   # natively on Wayland instead of XWayland. Also set inside Hyprland's Lua
   # env; setting it here too guarantees it for processes spawned outside the
   # Hyprland exec chain (e.g. systemd user services).
   environment.sessionVariables = {
     NIXOS_OZONE_WL = "1";
     # Hardware video decode via the AMD iGPU's Mesa VA-API driver. Correct for
     # the Ryzen 5 5000-series Vega graphics. Check it with `vainfo`.
     LIBVA_DRIVER_NAME = "radeonsi";
     NH_FLAKE = "/home/dheeraj/nixos";
     NH_OS_FLAKE = "/home/dheeraj/nixos";
   };

   # Override the XDG applications menu with a minimal one so KDE/Dolphin
   # resolves the configured default handler (Loupe for images) instead of
   # popping the "open with" picker on double-click under the Hyprland
   # (non-Plasma) session. See modules/dolphin.menu for the why.
   environment.etc."xdg/menus/applications.menu".source = ./modules/dolphin.menu;

   programs.fuse.userAllowOther = true;

   programs.nh = {
     enable = true;
     clean.enable = true;
     clean.extraArgs = "--keep-since 4d --keep 3";
     flake = "/home/dheeraj/nixos";
   };

   programs.nix-ld.enable = true;
   programs.nix-ld.libraries = with pkgs; [
    # Add common libraries extensions need (Claude Code needs basic glibc/gcc stuff)
    stdenv.cc.cc
    openssl
    zlib
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This is a plain personal laptop, not a machine anyone logs into remotely.
  # The ASUS config it was derived from ran a small always-on server stack —
  # all of it is deliberately absent here:
  #   - services.openssh          (no inbound SSH)
  #   - services.tailscale        (no mesh VPN)
  #   - services.code-server      (no browser VS Code on the tailnet)
  #   - services.avahi + uxplay   (no AirPlay receiver / mDNS advertising)
  #   - services.logind lid rules (see below)
  #   - custom firewall openings  (see below)
  #
  # Lid behaviour is left at the NixOS default, so closing the lid SUSPENDS
  # the laptop instead of staying awake. That is the normal laptop behaviour
  # and much better for battery; the old config only overrode it to keep SSH
  # reachable with the lid shut.
  #
  # The firewall stays enabled with no open ports — nothing here listens for
  # inbound connections. This also drops the old hardcoded `wlo1` trusted
  # interface, which would not have matched this laptop's Wi-Fi device name
  # anyway.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
  #env switch
  environment.shellAliases = {
    nixos-switch = "sudo nixos-rebuild switch --flake /home/dheeraj/nixos#dheeraj";

    # Portainer: Docker GUI at http://localhost:9000 (runs only when started).
    # First run creates the container; later runs just start the existing one.
    portainer-up = "docker start portainer 2>/dev/null || docker run -d -p 9000:9000 --name portainer --restart=no -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest";
    portainer-down = "docker stop portainer";
  };
}
