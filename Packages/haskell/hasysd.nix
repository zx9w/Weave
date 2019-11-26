{ pkgs, lib, config, ... }:
{
  systemd.services.srandrd = {
    description = "hello world from haskell";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = pkgs.writers.writeHaskell "srandrd" {} ''
        main = putStrLn "Hello, world!"
      '';
    };
  };
}
