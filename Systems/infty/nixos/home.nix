# run man home-configuration.nix to show available options
# inspiration: https://git.sr.ht/~ben/cfg/
# to install packages directly from nixkpgs master git branch, see https://stackoverflow.com/questions/38092553/nix-install-derivation-directly-from-master-branch

{ config, pkgs, ... }:

let
    # baseConfig = {
    #   allowUnfree = true;
    # };

    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
#    master = import (
#      fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {
#      config = { allowUnfree = true; };
#    };
    configdir = "/home/infty/config";

in

{

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  home.packages = with pkgs; [
    light
    stalonetray
    gnome3.networkmanagerapplet
    mullvad-vpn
    wireguard
    rstudio
    python37Packages.python-language-server
    python37
    irssi
    ag
    tdesktop
    zeal # offline documentation browser
    exa # ls replacement
    pazi # similar to autojump
    xclip
    autocutsel # unify clipboard
    deluge # torrent client
    redis
    gcc
    postgresql
    ncdu
    # python36
    redshift
    jq
    nix-bundle # provides nix run
    awscli
    docker
    kbfs
    keybase-gui
    keybase
    cheat
    qutebrowser
    acpi
    pandoc
    fzf
    tree
    htop
    xorg.xev
    ripgrep
    pass
    zathura
    dmenu
    ranger
    electrum
    tldr
    chromium
#    xorg.xbacklight
    powertop
    slack
    jetbrains.pycharm-community
  ];

  home.file = {
    ".mozilla/firefox/myprofile/chrome/userChrome.css".source = "${configdir}/firefox/userChrome.css";
    ".config/qutebrowser/config.py".source = "${configdir}/qutebrowser/config.py";
    ".local/share/qutebrowser/userscripts".source = "${configdir}/qutebrowser/userscripts/";
    ".xmonad/xmonad.hs".source = "${configdir}/xmonad/xmonad.hs";
    ".xmonad/autostart.sh".source = "${configdir}/xmonad/autostart.sh";
    ".config/cheat/conf.yml".source = "${configdir}/cheat/conf.yml";
    ".ideavimrc".source = "${configdir}/pycharm/ideavimrc";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
    git = {
      enable = true;
    }; 
    urxvt = {
      enable = true;
      scroll.bar.enable = false;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    rofi = {
      enable = true;
        extraConfig = ''
          ! the following line unbinds C-l to make it available for rebinding
          rofi.kb-remove-to-eol:
          rofi.kb-accept-entry: Control+l,Return,KP_Enter
          rofi.kb-row-up: Up,Control+k,ISO_Left_Tab
          rofi.kb-row-down: Down,Control+j
        '';
      };
    zathura = {
       enable = true;
       options = {
         default-bg = "#101215";
         selection-clipboard = "clipboard";
         recolor = "true";
       };
     };
    bash = {
      enable = true;
      historySize = 10000;
      historyIgnore = [ "l" "ls" "exit" "cd" ];
      initExtra = ''

# configure pazi, see https://github.com/euank/pazi /install
if command -v pazi &>/dev/null; then
  eval "$(pazi init bash)" # or 'zsh'
fi

# brohedge-related, see slack/vlado<2020-01-25 Sat>/
export TB=http://ec2-63-32-241-222.eu-west-1.compute.amazonaws.com
alias tunnel-eu='ssh -L 9001:redis.onr7bv.ng.0001.euw1.cache.amazonaws.com:6379 tb'

      '';
    };
    emacs.enable = true;
    firefox = {
      enable = true;
      extensions =
        with nur.repos.rycee.firefox-addons; [
          ublock-origin
          decentraleyes
        ];
      profiles = {
        myprofile = {
          id = 0;
          settings = {
            "browser.startup.homepage" = "about:blank";
            "browser.search.region" = "US";
            "browser.search.countryCode" = "US";
            "browser.search.isUS" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # tells firefox to look for userChrome.css
            "browser.aboutConfig.showWarning" = false;
            "browser.tabs.warnOnClose" = false;
            "browser.defaultbrowsernotificationbar" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.download.folderList" = 2;
            "browser.download.dir" = "/home/infty/downloads";
            "browser.ctrlTab.recentlyUsedOrder" = false; # prevent silly ctrl-tab behavior
          };
        };
      };
    };
  };

  services = {
    emacs.enable = true;
    unclutter.enable = true;
  };

  xresources.extraConfig = ''
    urxvt*urgentOnBell:       true
    ! special
    *.foreground:   #c5c8c6
    *.background:   #1d1f21
    *.cursorColor:  #c5c8c6
    ! black
    *.color0:       #282a2e
    *.color8:       #373b41
    ! red
    *.color1:       #a54242
    *.color9:       #cc6666
    ! green
    *.color2:       #8c9440
    *.color10:      #b5bd68
    ! yellow
    *.color3:       #de935f
    *.color11:      #f0c674
    ! blue
    *.color4:       #5f819d
    *.color12:      #81a2be
    ! magenta
    *.color5:       #85678f
    *.color13:      #b294bb
    ! cyan
    *.color6:       #5e8d87
    *.color14:      #8abeb7
    ! white
    *.color7:       #707880
    *.color15:      #c5c8c6
  '';

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf"               = [ "org.pwmt.zathura.desktop" ];
    "text/html"                     = [ "qutebrowser.desktop" ];
    "x-scheme-handler/http"         = [ "firefox.desktop" ];
    "x-scheme-handler/https"        = [ "firefox.desktop" ];
    "application/x-extension-htm"   = [ "firefox.desktop" ];
    "application/x-extension-html"  = [ "firefox.desktop" ];
    "application/x-extension-shtml" = [ "firefox.desktop" ];
    "application/xhtml+xml"         = [ "firefox.desktop" ];
    "application/x-extension-xht"   = [ "firefox.desktop" ];
    "image/png"                     = [ "feh.desktop" ];
    "image/vnd.djvu"                = [ "org.pwmt.zathura.desktop" ];
    "x-scheme-handler/about"        = [ "firefox.desktop" ];
    "x-scheme-handler/unknown"      = [ "firefox.desktop" ];
  };

}
