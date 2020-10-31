{ pkgs ? import <nixpkgs> {} }:


pkgs.writers.writeHaskellBin "mathify" {
  libraries = [];
} /* haskell */ ./Mathify.hs
