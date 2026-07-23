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

  # Lock screen + idle daemon (auto-lock at 30 min, suspend at 60 min).
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softSettle, 0.05, 0.7, 0.1, 1"
        ];
        "fade_in" = {
          duration = 280;
          bezier = "easeOutExpo";
        };
        "fade_out" = {
          duration = 180;
          bezier = "easeOutExpo";
        };
        "inputFieldColors" = {
          duration = 180;
          bezier = "softSettle";
        };
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          color = "rgba(05070aff)";
          blur_passes = 4;
          blur_size = 8;
          noise = 0.011;
          contrast = 0.9;
          brightness = 0.62;
          vibrancy = 0.22;
          vibrancy_darkness = 0.45;
        }
      ];

      shape = [
        {
          monitor = "";
          size = "560, 210";
          position = "0, -8";
          halign = "center";
          valign = "center";
          color = "rgba(0b0d12cc)";
          rounding = 22;
          border_size = 1;
          border_color = "rgba(9ccfd866)";
          shadow_passes = 3;
          shadow_size = 20;
          shadow_color = "rgba(00000066)";
        }
        {
          monitor = "";
          size = "560, 2";
          position = "0, 96";
          halign = "center";
          valign = "center";
          color = "rgba(c4a7e7cc)";
          rounding = 1;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] date +"%H:%M"'';
          position = "0, 58";
          halign = "center";
          valign = "center";
          color = "rgba(f7f3ffef)";
          font_family = "Inter";
          font_size = 52;
          shadow_passes = 2;
          shadow_size = 6;
          shadow_color = "rgba(00000055)";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B"'';
          position = "0, 8";
          halign = "center";
          valign = "center";
          color = "rgba(ebbcbaee)";
          font_family = "Inter";
          font_size = 15;
        }
        {
          monitor = "";
          text = "Welcome back, Dheeraj";
          position = "0, -72";
          halign = "center";
          valign = "center";
          color = "rgba(e0def4d9)";
          font_family = "Inter";
          font_size = 13;
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "280, 46";
          position = "0, -14";
          halign = "center";
          valign = "center";
          dots_center = true;
          dots_rounding = -1;
          dots_size = 0.2;
          dots_spacing = 0.28;
          fade_on_empty = false;
          font_color = "rgba(e0def4ff)";
          inner_color = "rgba(161821dd)";
          outer_color = "rgba(9ccfd8bb)";
          check_color = "rgba(f6c177ff)";
          fail_color = "rgba(eb6f92ff)";
          outline_thickness = 2;
          rounding = 16;
          placeholder_text = ''<span foreground="##908caa">Password</span>'';
          fail_text = ''<span foreground="##eb6f92">Nope, try again</span>'';
          shadow_passes = 2;
          shadow_size = 10;
          shadow_color = "rgba(00000044)";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      # Normal laptop idle behaviour. The ASUS config used much longer timeouts
      # and deliberately had NO suspend listener, because that machine had to
      # stay reachable over SSH/Tailscale while idle. This one is a personal
      # laptop, so it locks, blanks and then actually sleeps to save battery.
      listener = [
        # 5 min: lock the session.
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # 6 min: turn the panel off (the big battery win).
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # 15 min: suspend to RAM.
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
