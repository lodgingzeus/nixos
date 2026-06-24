{ lib, pkgs, config, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;       
    portalPackage = null;
    systemd.enable = true;
    # Write the classic hyprland.conf format 
    configType = "hyprlang";

    settings = {
      "$ipc" = "noctalia msg";
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "$ipc panel-toggle launcher";

      monitor = [ "eDP-1,preferred,auto,1.33" ];

      # Start the Noctalia shell + polkit agent (auth dialogs) on login.
      exec-once = [
        "noctalia"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "GTK_USE_PORTAL,1"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        # NVIDIA on Wayland (your panel is wired to the NVIDIA GPU).
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
        "NIXOS_OZONE_WL,1"
      ];

      general = {
        # Compact spacing and a quiet pastel edge keep the desktop airy
        # without wasting much of the laptop display.
        gaps_in = 4;
        gaps_out = 7;
        border_size = 1;
        "col.active_border" = "rgba(9ccfd8ee) rgba(c4a7e7ee) 45deg";
        "col.inactive_border" = "rgba(ffffff18)";
        resize_on_border = true;
        extend_border_grab_area = 35;
        hover_icon_on_border = true;
        layout = "dwindle";
      };

      decoration = {
        # Soft Material-like windows: readable first, glassy second.
        rounding = 17;
        rounding_power = 2.5;
        active_opacity = 0.96;
        inactive_opacity = 0.88;
        fullscreen_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.04;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 4;
          color = "rgba(05070a99)";
        };
        blur = {
          enabled = true;
          size = 9;
          passes = 3;
          brightness = 1.0;
          contrast = 0.9;
          noise = 0.015;
          vibrancy = 0.35;
        };
      };

      animations = {
        enabled = true;
        # Smooth and responsive rather than bouncy: workspace changes glide,
        # windows settle softly, and shell panels get out of the way quickly.
        bezier = [
          "easeOutQuint, 0.23, 1,    0.32, 1"
          "easeOutExpo,  0.16, 1,    0.30, 1"
          "easeInOut,    0.65, 0.05, 0.36, 1"
          "softPop,      0.20, 0.90, 0.20, 1.05"
          "quick,        0.15, 0,    0.10, 1"
          "linear,       0,    0,    1,    1"
        ];
        animation = [
          "global,        1, 10,  default"

          # Windows open with a subtle scale-up and close more quickly.
          "windows,       1, 4.5, easeOutExpo"
          "windowsIn,     1, 4.2, softPop,     popin 92%"
          "windowsOut,    1, 2.2, quick,       popin 96%"
          "windowsMove,   1, 4.0, easeOutQuint"
          "fadeIn,        1, 3.0, easeOutExpo"
          "fadeOut,       1, 2.0, quick"
          "fade,          1, 3.0, easeInOut"

          # Borders follow focus without drawing attention to themselves.
          "border,        1, 5.0, easeOutQuint"
          "borderangle,   1, 8.0, easeInOut"

          # Noctalia panels and notifications feel light and immediate.
          "layers,        1, 3.5, easeOutExpo"
          "layersIn,      1, 3.8, easeOutExpo, fade"
          "layersOut,     1, 2.2, quick,       fade"
          "fadeLayersIn,  1, 3.0, easeOutExpo"
          "fadeLayersOut, 1, 2.0, quick"

          # A directional slide makes workspace navigation easy to follow.
          "workspaces,    1, 4.5, easeOutExpo, slide"
          "workspacesIn,  1, 4.5, easeOutExpo, slide"
          "workspacesOut, 1, 4.0, easeOutExpo, slide"

          # Keep the special workspace distinct but restrained.
          "specialWorkspaceIn,  1, 4.0, softPop, slidevert"
          "specialWorkspaceOut, 1, 3.0, quick,   slidevert"
        ];
      };

      master = {
        new_status = "inherit";
        orientation = "center";
        slave_count_for_center_master = 0;
        drop_at_cursor = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        vrr = 0; # laptop panel — no variable refresh
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      };

      gesture = "3, horizontal, workspace"; # 3-finger swipe between workspaces

      # NVIDIA: software cursor avoids the invisible-cursor bug.
      cursor.no_hardware_cursors = 2;

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating"
        "$mainMod SHIFT, V, centerwindow"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, T, pin"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo"
        "$mainMod, Z, exec, $ipc panel-toggle control-center"
        "$mainMod, comma, exec, $ipc settings-toggle"
        "$mainMod SHIFT, c, exec, $ipc panel-toggle launcher clipboard"

        "$mainMod, left,  movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up,    movefocus, u"
        "$mainMod, down,  movefocus, d"

        "$mainMod SHIFT, left,  movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up,    movewindow, u"
        "$mainMod SHIFT, down,  movewindow, d"

        "$mainMod CTRL, left,  resizeactive, -40 0"
        "$mainMod CTRL, right, resizeactive, 40 0"
        "$mainMod CTRL, up,    resizeactive, 0 -40"
        "$mainMod CTRL, down,  resizeactive, 0 40"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up,   workspace, e-1"

        "$mainMod, minus, layoutmsg, splitratio -0.1"
        "$mainMod, equal, layoutmsg, splitratio 0.1"

        "$mainMod, print,       exec, hyprshot -m window --clipboard-only"
        ", print,               exec, hyprshot -m output --clipboard-only"
        "shift, print,          exec, hyprshot -m region --clipboard-only"
        "ctrl, print,           exec, hyprshot -m window"
        "ctrl $mainMod, print,  exec, hyprshot -m output"
        "ctrl shift, print,     exec, hyprshot -m region"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp,   exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext,  exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay,  exec, playerctl play-pause"
        ", XF86AudioPrev,  exec, playerctl previous"
      ];

      # Frost the Noctalia bar/panels (the glassmorphism touch).
      layerrule = {
        name = "noctalia";
        "match:namespace" = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
        ignore_alpha = 0.25;
        blur = true;
        blur_popups = true;
      };
    };
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
