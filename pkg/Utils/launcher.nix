{ pkgs }:

with builtins;

let
  fzf = "${pkgs.fzf}/bin/fzf";
  jq = "${pkgs.jq}/bin/jq";
in
  pkgs.writeShellScriptBin "launcher" ''
    eval $(${jq} '.$(${jq} 'keys' $1 | ${jq} .[] | ${fzf})')
  ''
