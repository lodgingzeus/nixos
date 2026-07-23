{ inputs, ... }:
{
  # Bring in Noctalia's Home Manager module.
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    # Launched by Hyprland's `exec-once` instead of a systemd service, so it
    # starts exactly once with the session. (No double-launch.)
    systemd.enable = false;

    settings.nightlight = {
      enabled = true;
      force = true;
      temperature_day = 6500;
      temperature_night = 4000;
    };
  };

  # Noctalia manages its own writable config in ~/.config/noctalia
}
