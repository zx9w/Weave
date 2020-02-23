{ config, pkgs, ... }:
let
  nix-writers = (import <nixpkgs> {}).fetchgit {
    url    = "https://cgit.krebsco.de/nix-writers";
    rev    = "c528cf970e292790b414b4c1c8c8e9d7e73b2a71";
    sha256 = "0xdivaca1hgbxs79jw9sv4gk4f81vy8kcyaff56hh2dgq2awyvw4";
  };
in {
  # include the repository as overlay
  nixpkgs.config.packageOverrides = import "${nix-writers}/pkgs" pkgs;
}
