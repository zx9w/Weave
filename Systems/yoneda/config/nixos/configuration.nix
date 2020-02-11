# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${home-manager}/nixos"
      <nixos-hardware/lenovo/thinkpad/t490>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.luks.devices = [{name = "root"; device = "/dev/nvme0n1p2"; preLVM = true;}];
  boot.initrd.luks.devices = { root = { device = "/dev/nvme0n1p2"; preLVM = true; }; };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    63.32.241.222 brohedge.com
  '';
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.100.0.2/24" ];
  #     privateKeyFile = "/home/infty/tmp/wire";
  #     peers = [
  #       {
  #         publicKey = "rZf+c8apRARS25iEKRWg7/QTnMUqyf26fOulgG+SCE8=";
  #         allowedIPs = [ "0.0.0.0/0"];
  #         endpoint = "141.98.254.66:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.wwp0s20f0u7.useDHCP = true;

  # Virtualization
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "infty" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim git rxvt_unicode dzen2
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    terminus_font
    source-code-pro
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Trying to enable backlit keyboard
  hardware.brightnessctl.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak";
  services.xserver.xkbOptions = "caps:swapescape";
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Brightness control
  hardware.acpilight.enable = true;
  programs.light.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.infty = {
    isNormalUser = true;
    home = "/home/infty";
    createHome = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" "input" ]; # Enable ‘sudo’ for the user.
  };

  # Home-manager as nix module
  home-manager.users.infty = import /home/infty/config/nixos/home.nix;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

