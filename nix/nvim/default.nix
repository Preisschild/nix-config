# Based on [Ali Abrar](https://github.com/ali-abrar)'s Vim configuration.

{ pkgs ? import <nixpkgs> {}, fetchGH, ... }:

let
  # cf. https://nixos.wiki/wiki/Vim#Adding_new_plugins 

  customPlugins = {
    neovim-ghcid = pkgs.vimUtils.buildVimPlugin {
      name = "ghcid";
      src = (fetchGH "ndmitchell/ghcid" "dfa37af") + "/plugins/nvim";
    };
    indenthaskell = pkgs.vimUtils.buildVimPlugin {
      name = "indenthaskell";
      src = fetchGH "vim-scripts/indenthaskell.vim" "17380713774ea4f3ca5da1de455126fa1cce82f7";
    };
    lastpos = pkgs.vimUtils.buildVimPlugin {
      name = "lastpos";
      src = fetchGH "vim-scripts/lastpos.vim" "21a22ce4a11117cae8a0017c1cd9a9094fe5adf2";
    };
    vim-ormolu = pkgs.vimUtils.buildVimPlugin {
      name = "vim-ormolu";
      src = fetchGH "sdiehl/vim-ormolu" "4ae4fe1";
    };
    vim-markdown-toc = pkgs.vimUtils.buildVimPlugin {
      name = "vim-markdown-toc";
      src = fetchGH "mzlogin/vim-markdown-toc" "25c6e3d";
    };
  };
in
  with pkgs; neovim.override {
    configure = {
      # Builtin packaging
      # List of plugins: nix-env -qaP -A nixos.vimPlugins
      packages.myVimPackage = with pkgs.vimPlugins; {
        # Loaded on launch
        start = [ ];
        # Manually loadable by calling `:packadd $plugin-name
        opt = [ ];
      };

      # VAM
      vam.knownPlugins = pkgs.vimPlugins // customPlugins;
      vam.pluginDictionaries = [
        { name = "goyo"; }  # Distraction free writing
        { name = "vim-auto-save"; }
        { name = "vim-nix"; }
        { name = "haskell-vim"; }
        { name = "vim-gitgutter"; }
        { name = "ctrlp"; }
        { name = "papercolor-theme"; }
        { name = "indenthaskell"; }
        { name = "nerdtree"; }
        { name = "lastpos"; }
        { name = "vim-nix"; }
        { name = "fugitive"; }
        { name = "tslime"; }
        { name = "fzf-vim"; }
        { name = "fzfWrapper"; }
        { name = "neovim-ghcid"; }
        { name = "coc-nvim"; }
        { name = "vim-airline"; }
        { name = "dhall-vim"; }
        { name = "vim-ormolu"; }
        { name = "vim-markdown-toc"; }
        # { name = "vim-stylish-haskell"; }
      ];

      customRC = 
        builtins.readFile ./config.vim  + builtins.readFile ./config-coc.vim;
    };
  }
