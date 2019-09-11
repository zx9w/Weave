{ pkgs, ... }:
pkgs.writeHaskellPackage "xmonad-ilmu" {
  executable.xmonad = {
    extra-depends = [
      "containers"
      "extra"
      "unix"
      "X11"
      "xmonad"
      "xmonad-contrib"
      "xmonad-extra"
      # "xmonad-zone"
    ];
    text = builtins.readFile ../Dot/Xmonad/xmonad.hs;
  };
}
