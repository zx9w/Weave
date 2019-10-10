# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../Modules/neovim.nix
      ../Modules/laptop.nix
      ../Modules/x.nix
      ../Modules/virtualisation.nix
    ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "simple-nixos"; # Define your hostname.
  # Not compatible with the networkmanager.enable option.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim curl emacs git zlib tmux feh acl
    xfontsel xlsfonts xscreensaver xclip kitty
    tmux tree htop imagemagick ripgrep
    fzf firefox which openssl gnupg libreoffice
    gimp-with-plugins zathura file jq scrot vlc
    tinc acpi unstable.go #   networkmanager
    wpa_supplicant wpa_supplicant_gui
    haskellPackages.ghc
    haskellPackages.stack
    haskellPackages.cabal-install
  ];

  # use shells for things like:
  # pkgconfig gnumake gcc binutils

  documentation.man.enable = true; 

  programs = {
    command-not-found.enable = true;
    slock.enable = true;
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Want to set up bouncer
  #services.tinc = {
  #  networks
  #}

  # services.acpid = {
  #   enable = true;
  #   handlers 

  environment.variables = {
    GOPATH = "/home/ilmu/Work/Go";
    SISU = "/home/ilmu/Work/Go/src/sisu.sh";
    SISU_AUTH_SECRET_KEY = "123456";
    BROKER_CLIENT_ID = "1234";
    BROKER_CLIENT_SECRET = "1234";
    DEFAULT_CLIENT_ID = "601673176557782";
    DEFAULT_CLIENT_SECRET = "g63ocune04hnr6a5136y3vcwpsidijxo";
  };


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
 
  # Postgres stuff, in case I want to enable it in the future.
  # services.postgresql = {
  #   enable = true;
  #   package = pkgs.postgresql;
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     local all all trust
  #     host all all ::1/128 trust
  #   '';
  #   initialScript = pkgs.writeText "backend-init-script" ''
  #     CREATE ROLE ilmu CREATEDB;
  #     CREATE DATABASE somedb;
  #     GRANT ALL PRIVILEGES ON DATABASE somedb TO ilmu;
  #   '';
  # };

  environment.shellAliases = lib.mkForce {
    ls="ls -h --color=auto --group-directories-first";
    iskb="setxkbmap is";
    uskb="setxkbmap us";
    todo="cat ~/todo.txt";
    toedit="vi ~/todo.txt";
    ec="emacsclient -c --socket-name=memacs";
    ecd="emacs --user=ilmu --daemon=memacs";
    ecg="emacsclient -c --socket-name=gomacs";
    ecgd="emacs --user=gomu --daemon=gomacs";
    eca="emacsclient -c --socket-name=auxmacs";
    ecad="emacs --user=auxmu --daemon=auxmacs";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.rishi = {
    name = "rishi";
    members = ["ilmu"];
    gid = 1666;
  };

  users.users.ilmu = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "vboxusers" "networkmanager" "rishi" ];
  };

  users.users.auxmu = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
  };

  users.users.gomu = {
    isNormalUser = true;
    uid = 1002;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
  };

  # As of now this doesn't work but it needs to be done to own the user.
  # environment.shellInit = ''
  #   setfacl -m "g:1666:rwx" /home/auxmu
  #   setfacl -m "g:1666:rwx" /home/gomu
  # '';

  # For machinery at work.
  networking.hosts = {
    "127.0.0.1" = [ "redis" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
