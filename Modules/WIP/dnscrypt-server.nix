{ config, ... }:
let
  port = 15200;
in {
  services.dnscrypt-wrapper = {
    enable = true;
    address = "0.0.0.0";
    upstream.address = "8.8.8.8";
    providerName = "2.dnscrypt-cert.<your server name>";
    inherit port;
  };
  networking.firewall.allowedUDPPorts = [ port ];
}
