{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = super: {
    nvim = super.neovim.override
       {
        configure = {
          customRC = builtins.readFile ../Dotfiles/vim.config;
          packages.nvim = with pkgs.vimPlugins; {
            start = [
              ale            # syntax highlighting
              airline
              gruvbox
              deoplete-nvim  # auto complete
              fzf-vim        # jump to file
              fzfWrapper     # seems like a nix thing
              nerdtree
              nerdtree-git-plugin
              tagbar
              supertab       # use tab to complete
              tabular        # alignment
              vim-commentary # make it easy to comment lines
              vim-eunuch     # unix commands from vim :SudoWrite
              vim-fugitive   # git integration
              vim-gitgutter  # fine grained git control
              vim-pandoc     # edit files as if they were markdown
              vim-pandoc-after
              vim-pandoc-syntax
              vim-repeat     #
              # vim-ripgrep
              vim-sensible   #
              vim-startify   #
              vim-surround   #
              # open file with <file>:<line-number>:<col-nr>
              (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
                name = "vim-fetch";
                src = pkgs.fetchFromGitHub {
                  owner = "wsdjeg";
                  repo = "vim-fetch";
                  rev = "76c08586e15e42055c9c21321d9fca0677442ecc";
                  sha256 = "0avcqjcqvxgj00r477ps54rjrwvmk5ygqm3qrzghbj9m1gpyp2kz";
                };
              })
            ];
            opt = [
              csv
              dhall-vim
              haskell-vim
              idris-vim
              rust-vim
              vim-javascript
              purescript-vim
              vim-nix
              vim-toml
              vimtex
              (pkgs.vimUtils.buildVimPluginFrom2Nix {
                name = "vim-orgmode";
                src = pkgs.fetchFromGitHub {
                  owner = "jceb";
                  repo = "vim-orgmode";
                  rev = "9143d469c06c0dda5fcc48410d0331edbdcf68a0";
                  sha256 = "0j6i68hfsb4328n776klz3zdjxwiajb9h60x02ccjkws2csk0p9w";
                };
              })
              (pkgs.vimUtils.buildVimPluginFrom2Nix {
                name = "jq.vim";
                src = pkgs.fetchFromGitHub {
                  owner = "vito-c";
                  repo = "jq.vim";
                  rev = "5baf8ed192cf267d30b84e3243d9aab3d4912e60";
                  sha256 = "1ykaxlli7b9wmhr8lpdalqxh7l4940jwhwm9pwlraga425h4r6z4";
                };
              })
            ];
          };
        };
      };
  };
  environment.variables.EDITOR = pkgs.lib.mkForce "nvim";
  environment.variables.VISUAL = pkgs.lib.mkForce "nvim";
  environment.shellAliases.vi = "nvim";

  environment.systemPackages = [ pkgs.nvim ];
}
