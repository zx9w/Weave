
{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../Modules/retiolum.nix
      ../Modules/neovim.nix
      ../Modules/laptop.nix
      ../Modules/x.nix
      ../Modules/virtualisation.nix
      ../Modules/util.nix
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

  networking.hostName = "uppreisn"; # Define your hostname.

  networking.networkmanager = {
    enable = true;
    # wifi.powersave = true; # when active suspends wifi if unused for timeperiod
  };


  # Retiolum Krebs VPN
  networking.retiolum = {
    ipv4 = "10.243.42.13";
    ipv6 = "42:0:3c46:bc8c:78fb:66b5:512c:7fbe";
    nodename = "uppreisn";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone. NOTE: Maybe redundant now with localtime.
  time.timeZone = "Europe/Berlin";

  # Allow unfree packages
  # nixpkgs.config = {
  #   allowunfree = true;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl vim emacs git dmenu zlib tmux
    xfontsel xlsfonts xscreensaver xclip feh
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.stack
    haskellPackages.hledger
    imagemagick stalonetray kitty tree vlc
    firefox which ripgrep alacritty fzf
    networkmanagerapplet htop zathura jq
    file scrot gnupg gimp-with-plugins
    inkscape which xorg.xev acpi arandr
    pavucontrol font-awesome_5 pass
    binutils gcc gnumake openssl pkgconfig
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;


  # I was having problems with DNSSEC questions to bitwala blocking protonmail
  # TODO Actually use this! It doesn't work right now but I'm lazy.
  # services.dnscrypt-proxy = {
  #   enable = true;
  #   resolverName = "ns0.dnscrypt.is";
  # };
  # networking.nameservers = ["127.0.0.1"];


  programs = {
    slock.enable = true; # TODO Switch to physlock
    command-not-found.enable = true;
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable postgres
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql96;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE ilmu CREATEDB;
      CREATE DATABASE jafnabackdb;
      GRANT ALL PRIVILEGES ON DATABASE jafnabackdb TO ilmu;
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ilmu = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "docker" "vboxusers"];
  };

  # Define Environment Variables, like $EDITOR
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    XDG_CONFIG_HOME = "/home/ilmu/.config/";
    GOPATH = "/home/ilmu/Projects/Go/";
    LEDGER_FILE = "/home/ilmu/Bureaucracy/Money/";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
