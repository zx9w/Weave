with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    ant adoptopenjdk-bin
  ];
}

