{ pkgs }:

pkgs.writeShellScriptBin "know" ''
  cat ~/bin/todo.txt
''
