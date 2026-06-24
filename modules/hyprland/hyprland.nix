{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = true;
    configType = "lua";

    # Keep source concerns modular, then compose one self-contained Lua file.
    # This works both at runtime and with Hyprland's Nix-store parser checks.
    extraConfig = lib.concatStringsSep "\n" (
      map builtins.readFile [
        ./hyprland.lua
        ./lua/environment.lua
        ./lua/appearance.lua
        ./lua/animations.lua
        ./lua/input.lua
        ./lua/bindings.lua
        ./lua/rules.lua
      ]
    );
  };

  xdg.configFile = {
    "hypr/hyprland/environment.lua".source = ./lua/environment.lua;
    "hypr/hyprland/appearance.lua".source = ./lua/appearance.lua;
    "hypr/hyprland/animations.lua".source = ./lua/animations.lua;
    "hypr/hyprland/input.lua".source = ./lua/input.lua;
    "hypr/hyprland/bindings.lua".source = ./lua/bindings.lua;
    "hypr/hyprland/rules.lua".source = ./lua/rules.lua;
  };

  # Lock screen + idle daemon (auto-lock at 10 min, suspend at 15 min).
  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
