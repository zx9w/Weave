{ pkgs, ... }:
{
  services.openvpn.servers = {
    officeVPN = {
      config = '' config /home/ilmu/Work/SSH/hjoervar.ovpn '';
    };
  };
}
