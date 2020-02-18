{
  packageOverrides = super: let self = super.pkgs; in
  {
    xmonadDevEnv = self.haskell.package.ghc865.ghcWithPackages
    (haskellPackages: with haskellPackages; [
      # libraries
      xmonad xmonad-contrib xmonad-extras
      # tools
      cabal-install
      ]);
    };
  }
