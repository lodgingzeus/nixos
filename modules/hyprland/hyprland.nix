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

      monitor = [ ",preferred,auto,1" ];

      # Start the Noctalia shell + polkit agent (auth dialogs) on login.
      exec-once = [
        "noctalia"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [
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
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        resize_on_border = true;
        extend_border_grab_area = 35;
        hover_icon_on_border = true;
        layout = "master";
      };

      decoration = {
        rounding = 5;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,   0.23, 1,    0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear,         0,    0,    1,    1"
          "almostLinear,   0.5,  0.5,  0.75, 1"
          "quick,          0.15, 0,    0.1,  1"
        ];
        animation = [
          "global,        1, 10,   default"
          "border,        1, 5.39, easeOutQuint"
          "windows,       1, 4.79, easeOutQuint"
          "windowsIn,     1, 4.1,  easeOutQuint, popin 87%"
          "windowsOut,    1, 1.49, linear,       popin 87%"
          "fadeIn,        1, 1.73, almostLinear"
          "fadeOut,       1, 1.46, almostLinear"
          "fade,          1, 3.03, quick"
          "layers,        1, 3.81, easeOutQuint"
          "layersIn,      1, 4,    easeOutQuint, fade"
          "layersOut,     1, 1.5,  linear,       fade"
          "fadeLayersIn,  1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces,    1, 1.94, almostLinear, fade"
          "workspacesIn,  1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
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
        disable_hyprland_logo = false;
        vrr = 0; # laptop panel — no variable refresh
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
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

        "$mainMod, minus, splitratio, -0.1"
        "$mainMod, equal, splitratio, 0.1"

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
        ignore_alpha = 0.5;
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
