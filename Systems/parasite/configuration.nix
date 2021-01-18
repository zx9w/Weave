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
  # $ nix-shell -I nixpkgs=channel:nixos-unstable -p nixos-generators
  # $ nixos-generate -I nixpkgs=channel:nixos-unstable -f iso -c configuration.nix

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

  environment.systemPackages = with pkgs; [

    # Work with files
    vim emacs tmux
    git gitui
    zlib zip unzip
    pandoc p7zip

    # Search, query and overview
    ripgrep fd
    which file
    tree bat tokei

    # Monitor or configure
    htop acpi procs
    pavucontrol arandr navi

    # X stuff
    xfontsel xlsfonts xscreensaver xclip xmobar

    # Image makers
    imagemagick gimp-with-plugins inkscape krita
    scrot

    # Viewers
    kitty libreoffice zathura vlc feh viu

    # Security
    openssl gnupg openssh tinc nitrokey-app

    # Make more parasites
    nixos-generators

    # Internet
    brave firefox qutebrowser
    wget curl
    wireshark
    youtube-dl rtorrent

    # Communication
    wire-desktop tdesktop signal-desktop
    texlive gnuplot

    # Programming
    sbcl racket guile clojure
    gcc cargo racer rustup zig
    julia jq go dhall
    lean coq agda # idris
    haskellPackages.ghc
    haskellPackages.cabal-install

    # Program Analysis
    valgrind gdb binutils hyperfine pkgconfig
  ];

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
