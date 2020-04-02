{ config, options, pkgs, lib, ... }:
{
  options = {
    services.xserver.displayManager.background = lib.options.mkOption {
      type = lib.types.path;
      example = /path/to/picture;
      default = ~/Memes/108-architecture.png;
      description = "Path to desktop background";
    };
  };

  config = {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      layout = "us,is";
      xkbOptions = "caps:hyper";
      libinput.enable = true; # Enable touchpad support.
      windowManager.default = "xmonad";
      windowManager.session = [{
        name = "xmonad";
        start = ''
          ${pkgs.xorg.xhost}/bin/xhost +LOCAL:
          ${pkgs.systemd}/bin/systemctl --user start xmonad
          exec ${pkgs.coreutils}/bin/sleep infinity
        '';
      }];

      displayManager = {
        sessionCommands = ''
          ${pkgs.feh}/bin/feh --no-fehbg --bg-max ${toString config.services.xserver.displayManager.background}
        '';
      };
    };

    # breaks xmonad
    # DISPLAY = ":${toString config.services.xserver.display}";
    systemd.user.services.xmonad = {
      environment = {
        XMONAD_DATA_DIR = "/tmp";
      };
      serviceConfig = {
        SyslogIdentifier = "xmonad";
        ExecStart = "${pkgs.xmonad-user}/bin/xmonad";
        ExecStop = "${pkgs.xmonad-user}/bin/xmonad --shutdown";
      };
      restartIfChanged = false;
    };
  };
}
