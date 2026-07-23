# Dheeraj's NixOS config — Lenovo IdeaPad (Ryzen 5 5000, integrated graphics)

Derived from the ASUS config in the parent directory. Same desktop (Hyprland +
Noctalia, Plasma/SDDM login, kitty, theming, dev tooling); the laptop-specific
hardware bits and the always-on server stack have been stripped.

## Install

1. **Install base NixOS** from the ISO. Partition and mount as usual.

2. **Put this folder at `~/nixos` on the new machine.** The contents of
   `dheeraj/` become `~/nixos/` — not `~/nixos/dheeraj/`. Every path inside the
   config assumes `/home/dheeraj/nixos`.

   ```bash
   git clone https://github.com/lodgingzeus/nixos /tmp/cfg
   mkdir -p /mnt/home/dheeraj
   cp -r /tmp/cfg/dheeraj /mnt/home/dheeraj/nixos
   ```

3. **Regenerate `hardware-configuration.nix` — before any rebuild.**

   ```bash
   sudo nixos-generate-config --root /mnt
   sudo cp /mnt/etc/nixos/hardware-configuration.nix \
           /mnt/home/dheeraj/nixos/hardware-configuration.nix
   ```

   The file shipped here is an intentionally broken placeholder. Skipping this
   step gives a clear build error, not a broken boot.

4. **Build:**

   ```bash
   sudo nixos-rebuild switch --flake /home/dheeraj/nixos#dheeraj
   ```

5. **Set a real password.** The config ships `initialPassword = "changeme"`,
   which is world-readable in the Nix store. After the first login:

   ```bash
   passwd
   ```

   Then delete the `initialPassword` line from `configuration.nix`.

### If `~/nixos` is a git repo

Flakes only see **git-tracked** files. If you copy this folder into a directory
that is already a git repo, run `git add -A` before rebuilding, or Nix will
silently not see the files. If `~/nixos` is not a git repo at all, this does not
apply.

## What changed vs the ASUS config

**Hardware**

| Removed | Why |
|---|---|
| `hardware.nvidia` + PRIME block, `videoDrivers = ["nvidia"]` | No discrete GPU. The bus IDs were physical addresses on the ASUS board. |
| `services.asusd`, `services.supergfxd`, `/etc/asusd` tmpfiles rule | ASUS-only firmware daemons. |
| Spotify `--force-device-scale-factor=1.33` wrapper | Only needed at fractional scale; this panel runs at 1.0. |

Kept and still correct for Ryzen 5 5000 (Vega): `LIBVA_DRIVER_NAME =
"radeonsi"`, `acpi_backlight=native`, `hardware.graphics.enable`.

**Server / remote-access stack — all removed**

`services.openssh`, `services.tailscale`, `services.code-server`,
`services.avahi`, the `uxplay` package, `tigervnc`, `deskflow`, every custom
firewall port (Tailscale 41641, mDNS 5353, AirPlay 6362/7000/7001/7100, Deskflow
24800), the `wlo1`/`tailscale0` trusted interfaces, and the `logind` lid-switch
overrides.

Consequences worth knowing:

- **Closing the lid now suspends the laptop.** That is the NixOS default and
  much better for battery. The old config only overrode it to keep SSH alive.
- **The firewall is on with zero open ports.** Nothing listens for inbound
  connections.
- **Wi-Fi powersave is back on** (the old `wifi.powersave = false` existed only
  to keep SSH reachable while idle).

**Identity**

`deepak` → `dheeraj` throughout: username, `/home/dheeraj`, hostname `dheeraj`,
and the flake output is now `nixosConfigurations.dheeraj`. The personal
`mount-rsks` sshfs alias was dropped.

**Display**

`modules/hyprland/lua/environment.lua` now has a single catch-all monitor rule
at `scale = 1.0` for the 1920x1200 panel. The hardcoded external-monitor rule
(a Lenovo Legion 27Q-10 on the ASUS's dGPU-wired HDMI port) is gone;
`mode = "preferred"` adapts to whatever gets plugged in.

## Tuning after first boot

- **UI too small?** Raise `scale` in `environment.lua`. If you go fractional
  (1.25, 1.33), re-enable `force_zero_scaling` — the commented block at the
  bottom of that file explains it.
- **Brightness keys dead?** Remove `acpi_backlight=native` from
  `boot.kernelParams` in `configuration.nix`.
- **Idle timeouts** — `modules/hyprland/hyprland.nix` (`services.hypridle`) locks
  at 5 min, blanks the screen at 6 min, suspends at 15 min. These are chosen
  defaults, not carried over; adjust to taste.
- **Autostart apps** — `environment.lua` launches Chrome, VS Code and Spotify on
  login. Edit the `hyprland.start` hook if that is not wanted.
- **Multi-monitor keybinds** in `bindings.lua` (`Super+Alt+Left/Right`) assume a
  horizontal arrangement; harmless with one screen.
