{ pkgs }:

pkgs.writeShellScriptBin "iskb" ''
  ${pkgs.xorg.setxkbmap}/bin/setxkbmap is
''
