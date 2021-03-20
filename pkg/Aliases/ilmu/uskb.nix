{ pkgs }:

pkgs.writeShellScriptBin "uskb" ''
  ${pkgs.xorg.setxkbmap}/bin/setxkbmap us
''
