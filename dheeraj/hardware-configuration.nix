# ============================================================================
#  PLACEHOLDER — REPLACE THIS FILE BEFORE THE FIRST REBUILD
# ============================================================================
#
# This is NOT a usable hardware configuration. It is a deliberately incomplete
# stub so that a rebuild fails loudly ("the ‘fileSystems’ option does not
# specify your root file system") instead of quietly booting with the wrong
# disk UUIDs.
#
# The real file is generated ON the target laptop and describes THAT machine's
# disks, partitions and CPU. It can never be copied between machines: it
# hardcodes filesystem UUIDs, and the wrong UUIDs mean the system will not boot.
#
# To generate it, on the new laptop, after partitioning and mounting:
#
#     sudo nixos-generate-config --root /mnt
#     sudo cp /mnt/etc/nixos/hardware-configuration.nix \
#             /mnt/home/dheeraj/nixos/hardware-configuration.nix
#
# ...overwriting this file. On a Ryzen 5 5000-series machine the generated file
# should contain `boot.kernelModules = [ "kvm-amd" ]` and
# `hardware.cpu.amd.updateMicrocode`. If it says `kvm-intel` instead, you are
# not on the CPU this config was written for — check before continuing.
# ============================================================================

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
