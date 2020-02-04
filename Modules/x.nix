{ pkgs, ... }:
{
  # let xmonad-ilmu = import...
#in
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us,is";
    xkbOptions = "eurosign:e";
    libinput.enable = true; # Enable touchpad support.
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-extras
        haskellPackages.xmonad-contrib
      ];
      config = ../Config/Xmonad/xmonad.hs;
    };
    windowManager.default = "xmonad";
  };


  services.xserver.displayManager.sddm.enable = true;

  # Enable the KDE Desktop Environment - Disable ASAP
  services.xserver.desktopManager.plasma5.enable = true;

}
