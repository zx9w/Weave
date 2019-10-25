with import <nixpkgs> {};

let
  know = pkgs.writeShellScriptBin "know1" ''
    date
    ${pkgs.acpi}/bin/acpi
    echo
    head -5 ~/todo.txt
  '';
in
stdenv.mkDerivation rec {
  name = "test-environment";

  buildInputs = [ know ];
}
