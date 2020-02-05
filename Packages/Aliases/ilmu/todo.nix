{ pkgs, todofilepath }:

pkgs.writeShellScriptBin "todo" ''
  cat ${todofilepath}
''
