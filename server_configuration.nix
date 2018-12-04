# NixOS Configuration file for Server

{ config, pkgs, ... }:

{
  # Hardware Configuration
  imports = [ ./hardware-configuration.nix ];
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ]; # SSD
  fileSystems."/datalake" = { device = "datalake"; fsType = "zfs"; };

  # System Configuration
  system.stateVersion = "17.03";
  system.autoUpgrade.enable = true;
  time.timeZone = "America/Los_Angeles";
  services.nixosManual.showManual = true;

  # Boot Configuration
  ## Not GRUB!
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" "zfs" ];
  
  # User Configuration
  users.extraUsers.remingtonc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "networkmanager" "systemd-journal" "docker" ];
  };

  # Networking Configuration
  networking.hostName = "Valhalla";
  networking.hostId = "e4ec3c0f";
  ## Connectivity
  networking.enableIPv6 = false;
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "208.67.222.222" "208.67.220.220"];
  networking.interfaces.enp0s3.ip4 = [ { address = "192.168.1.5"; prefixLength = 24; } ];
  ## Firewall
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 20 21 22 25 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  ## Virtualized networking
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "enp0s3";
  
  # Manageability Configuration
  services.openssh.enable = true;
  services.fail2ban.enable = true;
  
  # Services Configuration
  ## Media
  services.plex.enable = true;
  services.plex.openFirewall = true;
  ## DDClient
  services.ddclient.enable = true;
  services.ddclient.use = "web, web=dynamicdns.park-your-domain.com/getip"
  services.ddclient.protocol = "namecheap"
  services.ddclient.server = "dynamicdns.park-your-domain.com"
  services.ddclient.username = "remington.io";
  services.ddclient.password = "CHANGE ME";
  services.ddclient.domain = "@";
  ## System
  services.acpid.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    wget
    gcc
    go
    sqlite
    valgrind
    cmake
    bind
    git
    htop
    iftop
    iotop
    lshw
    tcpdump
    unzip
    which
    docker
    python3.5-glances-2.8.2
  ];
}
