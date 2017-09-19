# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Optimize for SSD
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  networking.hostName = "Odin"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  environment.systemPackages = with pkgs; [
    wget
    firefox
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
    spotify
    vlc
    atom
    docker
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 20 21 22 25 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;
  networking.enableIPv6 = false;
  networking.nameservers = [ "208.67.222.222" "208.67.220.220"];
  networking.firewall.allowPing = true;
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "wlp1s0";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  services.nixosManual.showManual = true;

  hardware.opengl.driSupport32Bit = true;
  services.acpid.enable = true;
  users.extraUsers.remingtonc = {
    isNormalUser = true;
    createHome = true;
    home = "/home/remingtonc";
    uid = 1000;
    extraGroups = [ "wheel" "disk" "video" "networkmanager" 
"systemd-journal" "audio" "docker" ];
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
  nixpkgs.config.allowUnfree = true;
}
