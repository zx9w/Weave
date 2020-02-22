{ pkgs, ... }:
{
  # Enable postgres
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql96;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE ilmu CREATEDB;
      CREATE DATABASE jafnabackdb;
      GRANT ALL PRIVILEGES ON DATABASE jafnabackdb TO ilmu;
    '';
  };
}
