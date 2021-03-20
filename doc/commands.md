# Invocations


## Package

Here is file called `filename.nix`

```
{ pkgs, ... }:
let
  nixvariable = "awesome thing to print";
in
  pkgs.writers.writeHaskell "binName" {
    libraries = [];
  } ''
    main = putStrLn "${nixvariable}"
  ''
```

This file can be built with:

`nix-build -E 'with import <nixpkgs> {}; callPackage ./filename.nix'`

or

`nix-shell -E 'with import <nixpkgs> {}; callPackage ./filename.nix'`

```
$ binName
awesome thing to print
```


## Derivation

You can also create another file, like `default.nix`.

```
with import <nixpkgs> {};
callPackage ./test.nix {}
```

Now the file can be called using:

`nix-build default.nix` or just `nix-build`
