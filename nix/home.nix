# https://nixos.wiki/wiki/Home_Manager

# Stuff on this file should work across all of my computing devices. 
# Presently these are: Thinkpad, Macbook and Pixel Slate.

{ config, pkgs, ...}:

let
  coinSound = pkgs.fetchurl {
    url = "https://themushroomkingdom.net/sounds/wav/smw/smw_coin.wav";
    sha256 = "18c7dfhkaz9ybp3m52n1is9nmmkq18b1i82g6vgzy7cbr2y07h93";
  };
  coin = pkgs.writeShellScriptBin "coin" ''
    ${pkgs.sox}/bin/play --no-show-progress ${coinSound}
  '';
in
{
  imports = [
    ./ihaskell.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (callPackage (import ./nvim/default.nix) {})
    dejavu_fonts
    source-serif-pro
    emacs
    sqlite gcc  # For emacsql
    aria
    cachix
    htop
    coin
    dict
    exa
    file
    fortune
    gron
    ii # suckless irc client
    mosh
    mpv
    ripgrep
    sshfs
    taskwarrior
    tig
    transmission
    wireguard
    youtube-dl
    haskellPackages.pandoc
  ];

  home.sessionVariables = {
    # https://github.com/syl20bnr/spacemacs/wiki/Terminal
    TERM = "xterm-24bit";
    EDITOR = "emacs -nw";
  };

  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      l = "exa";
      ls = "exa";
      copy = "xclip -i -selection clipboard";
      g = "git";
      e = "eval $EDITOR";
      ee = "e (fzf)";
      download = "aria2c --file-allocation=none --seed-time=0";
      chromecast = "castnow --address 192.168.2.64 --myip 192.168.2.76";
      gotty-sridca = "gotty -a 0.0.0.0 -p 9999 -r"; # To be run from the thebeast wireguard peer only.
    };
  };

  programs.bash = {
    enable = true;
    historyIgnore = [ "l" "ls" "cd" "exit" ];
    historyControl = [ "erasedups" ];
    enableAutojump = true;
    shellAliases = {
      l = "exa";
      ls = "exa";
      copy = "xclip -i -selection clipboard";
      g = "git";
      e = "$EDITOR";
      ee = "e $(fzf)";
      download = "aria2c --file-allocation=none --seed-time=0";
      chromecast = "castnow --address 192.168.2.64 --myip 192.168.2.76";
    };
    initExtra = ''
    if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then 
      . ~/.nix-profile/etc/profile.d/nix.sh; 
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    fi # added by Nix installer
    '';
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Sridhar Ratnakumar";
    userEmail = "srid@srid.ca";
    ignores = [ "*~" "*ghcid.txt" ];
    aliases = {
      co = "checkout";
      ci = "commit";
      s = "status";
      st = "status";
      d = "diff";
      pr = "pull --rebase";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
    };
    extraConfig = {
      core = {
        editor = "$EDITOR";
      };
    };
  };
  programs.command-not-found.enable = true;

  # This thing is rather unstable (for instance, the android app crashes)
  services.syncthing = {
    enable = false;
    tray = true;
  };

  services.ihaskell = {
    enable = true;
    notebooksPath = "$HOME/ihaskell";
    extraPackages = haskellPackages: with haskellPackages; [
      groom
      streamly
      mmark
      megaparsec
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # Automounter for removable media.
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  services.redshift = {
    enable = true;
    tray = true;
    # Quebec City
    latitude = "46.8423";
    longitude = "-71.2429";
  };

  home.file = {
    ".stylish-haskell.yaml".source = ../stylish-haskell.yaml;
    ".ghci".text = ''
      :set prompt "λ> "
    '';
  };
}
