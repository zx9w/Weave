{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    (import ./launcher.nix { inherit pkgs; })
  ];
}

