# Made for Linode.

{ config, pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./nix/base.nix
    ./nix/emacs.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # For Linode LISH console
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  networking.hostName = "tinix";
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  services.openssh.ports = [9812];
  users.extraUsers.srid = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDxb8ZoHT4EYdGjSslIUMSFrsoRh/4cdRJXBgS0878Kv/rDRR+f33bh9Hunmx0m78g5bG3/b6C4AMmfcqgw7XvT6yuW0NGjKQeOQtCX6FSu5F+cEv63r7FSjAXEQ6FkJHaFELG2f1wIU43mCVTutAQsiLy0a7NaH7EyxCk1OUXN4FByd2slqGPeLfDEjNQLGiZaYrG4VEfkl1jlgSHWK9ryiahp9IuR4mOTtwRf7fl4DoCAKpEY5jGNZJTe2HubzMAjtxSVcR5KWd7kJYVLw3SsA3NC8o8k9K0rFj2WDKHst0dpBfYjPTYnWZAu3hytrTxS/IB87XUtFjBwQhQk59b srid@MacBook-Pro-de-Sridhar.local"
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  # My apps
  services.nginx = {
    enable = false;
    user = "srid";
    virtualHosts={
      "www.srid.ca" = {
        enableACME = true;
        forceSSL = true;
        root = "/home/srid/sridCaOutput";
      };

      "slownews.srid.ca" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3001";
        };
      };
    };
  };

  # security.acme.certs = {
  #   "slownews.srid.ca".email = "srid@srid.ca";
  #   "www.srid.ca".email = "srid@srid.ca";
  # };
}
