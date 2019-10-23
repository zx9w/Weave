{ pkgs, todofilepath }:

pkgs.writeShellScriptBin "toedit" ''
  ${pkgs.nvim}/bin/nvim ${todofilepath}
''
