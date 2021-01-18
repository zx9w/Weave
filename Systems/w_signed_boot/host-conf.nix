{ config, pkgs, lib, ... }:

with lib;

{
  imports = [
    # <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
    # ./kexec.nix
    # ./unlock.nix
  ];

  environment.systemPackages = with pkgs; [
    lvm2 nitrokey-app cryptsetup
  ];
}
