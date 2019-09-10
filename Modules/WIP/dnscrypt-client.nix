{ ... }:
let
  customResolver = {
    address = <your server ip>;
    port = 15200;
    name = "2.dnscrypt-cert.<your server name>";
    ## log into the server and run this command in /var/lib/dnscrypt-wrapper
    # dnscrypt-wrapper --show-provider-publickey --provider-publickey-file public.key
    key = "0000:1111:2222:3333:4444:5555:6666:7777:8888:9999:AAAA:BBBB:CCCC:DDDD:EEEE:FFFF";
  };
in {
  services.dnscrypt-proxy = {
    enable = true;
    inherit customResolver;
  };
  networking.extraResolvconfConf = ''
    name_servers='127.0.0.1'
  '';
}

