# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../Modules/neovim.nix
      ../../Modules/laptop.nix
      ../../Modules/util.nix
      ../../Modules/x.nix
      ../../Modules/virtualisation.nix
      ../../Modules/alias.nix
      ../../Modules/bluetooth.nix
      ../../Modules/berlin.nix
    ];

  # This config is for a usb stick to keep around.

  networking.hostName = "parasite"; # Define your hostname.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.interfaces.wwp0s20u4i6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

 nixpkgs.config = {
  #  allowUnfree = true;
    allowBroken = true;
    packageOverrides = oldpkgs: {
 #     unstable = import <nixos-unstable> {
  #      config = config.nixpkgs.config;
   #   };
      xmonad-user = (oldpkgs.callPackage ../../Packages/xmonad.nix {username="ilmu";});
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim curl emacs git zlib tmux feh
    xfontsel xlsfonts xscreensaver xclip
    tree htop imagemagick ripgrep fd
    which openssl gnupg libreoffice kitty
    gimp-with-plugins zathura file scrot
    tinc acpi openssh pavucontrol vlc
    nitrokey-app firefox qutebrowser
    nixos-generators sbcl
    haskellPackages.ghc
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

  # environment.variables = {
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

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
    todo="touch ~/todo.txt && cat ~/todo.txt";
    toedit="nvim ~/todo.txt";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # TODO: Move to module along with nitrokey-app
  hardware.nitrokey.enable = true;
  hardware.nitrokey.group = "wheel";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilmu = {
    isNormalUser = true;
    password = "password";
    uid = 1000;
    extraGroups = [ "wheel" "docker" "vboxusers" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}
