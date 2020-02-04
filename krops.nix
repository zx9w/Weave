let
  krops = builtins.fetchGit {
    url = "https://cgit.krebsco.de/krops/";
  };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};

  source = lib.evalSource [
    {
      nixpkgs.git = {
        ref = "nixos-19.09";
        url = https://github.com/NixOS/nixpkgs-channels;
      };
      nixos-config.file = toString ./configuration.nix;
    }
  ];
in {
  uppreisn = pkgs.krops.writeDeploy "deploy-uppreisn" {
    source = source;
    target = "ilmu@uppreisn";
  };
}
