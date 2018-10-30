# https://nixos.wiki/wiki/Home_Manager

{ config, pkgs, ...}:

{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];
  home-manager.users.srid = {
    home.packages = with pkgs; [
      fortune
      dict
    ];

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "srid";
      userEmail = "srid@srid.ca";
      ignores = [ "*~" "*ghcid.txt" ];
    };
    programs.command-not-found.enable = true;

    services.screen-locker = {
      enable = true;
      inactiveInterval = 3;
    };

    home.file = {
      ".stylish-haskell.yaml".source = ../stylish-haskell.yaml;
      ".spacemacs".source = ../spacemacs;
    };

  };
}