{ pkgs, ... }:
{
  # for redshift, cause I'm lazy, TODO switch to lat/lon
  # services.geoclue2.enable = true;
  # services.localtime.enable = true;

  services.redshift = {
    enable = true;
    # brightness.day   = "1.0"; # min 0.1
    # brightness.night = "0.4"; # min 0.1
    temperature.day   = 5500; # default d: 5500, n: 3700
    temperature.night = 2700; # possible: 1000-25000
    latitude = "52.3";
    longitude = "13.2";
    # provider = "geoclue2"; # must specify lat/lon if "manual"
  };

  services.logind = {
    lidSwitch = "ignore"; # "hybrid-sleep";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = "HandlePowerKey=hybrid-sleep";
  };

  # This should allow logind to hibernate the computer when I close it
  security.sudo.extraConfig = ''
    ilmu ALL=NOPASSWD: /run/current-system/sw/bin/systemctl suspend,/run/current-system/sw/bin/systemctl hibernate,/run/current-system/sw/bin/systemctl hybrid-sleep,/run/current-system/sw/bin/systemctl suspend-then-hibernate
    '';

 # powerManagement = {
 #   enable = true;
 #   powertop.enable = true;
 # };

#  services.acpid = {
#    enable = true;
    # need to learn how to handlers
#   lidEventCommands = ''
#     event=button[ /]lid
#     action=~/bin/lidclose.sh
#   '';

#  };

  # Battery Management - From online
  services.tlp.enable = true;

  # powerManagement.powerUpCommands
  # powerManagement.powerDownCommands
}
