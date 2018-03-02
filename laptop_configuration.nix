# NixOS Configuration file for Laptop

{ config, pkgs, ... }:

{
  # Hardware Configuration
  imports = [ ./hardware-configuration.nix ];
  ## Audio
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
  ## Graphics
  hardware.opengl.driSupport32Bit = true; # Games?
  ## Bluetooth
  hardware.bluetooth.enable = true;
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ]; # SSD

  # System Configuration
  system.stateVersion = "17.09";
  system.autoUpgrade.enable = true;
  time.timeZone = "America/Los_Angeles";
  services.nixosManual.showManual = true;

  # Boot Configuration
  ## Not GRUB!
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # User Configuration
  users.extraUsers.remingtonc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "video" "networkmanager" "systemd-journal" "audio" "docker" ];
  };

  # Networking Configuration
  networking.hostName = "Odin";
  ## Connectivity
  networking.enableIPv6 = false;
  networking.nameservers = [ "208.67.222.222" "208.67.220.220"];
  networking.firewall.allowPing = true;
  networking.networkmanager.enable = true;
  ## Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 20 21 22 25 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  ## Virtualized networking
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "wlp1s0";
  
  # Manageability Configuration
  services.openssh.enable = true;
  
  # Services Configuration
  ## CUPS
  services.printing.enable = true;
  ## X11
  services.xserver.enable = true;
  services.xserver.layout = "us";
  ## Trackpad
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  ## DE
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  ## System
  services.acpid.enable = true;

  # Packages
  ## No idea what I'm doing with these settings
  programs.fish.enable = true;
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  programs.ssh.enable = true;
  programs.nano.enable = true;
  programs.vim.enable = true;
  programs.man.enable = true;
  ## Actually request packages now
  nixpkgs.config.allowUnfree = true; # Required for Spotify :)
  environment.systemPackages = with pkgs; [
    docker
    spotify
    vlc
    firefox
    vscode
    alacritty
    tmux
    bash
    fish
    mosh
    git
    htop
    iftop
    iotop
    lshw
    tcpdump
    unzip
    which
    wget
    curl
    bind
    dig
  ];
}
