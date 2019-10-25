with import <nixpkgs> {};

let
  find-command = pkgs.writeShellScriptBin "fcmd" ''
    {pkgs.bash-interactive}/bin/compgen -c | ${pkgs.ripgrep}/bin/rg $1
  '';
in
stdenv.mkDerivation rec {
  name = "test-environment";

  buildInputs = [ find-command ];
}
