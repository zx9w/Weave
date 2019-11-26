{ pkgs, lib, config, ... }:
{
  systemd.services.hasysd = {
    description = "hello world from haskell";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = pkgs.writers.writeHaskell "hasysd" {} ''
        main = putStrLn "Hello, world!"
      '';
    };
  };
}
