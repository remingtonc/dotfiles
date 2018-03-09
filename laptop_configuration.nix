# NixOS Configuration file for Laptop

{ config, pkgs, ... }:

{
  # Hardware Configuration
  imports = [ ./hardware-configuration.nix ];
  hardware = {
    ## Audio
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    ## Bluetooth
    bluetooth.enable = true;
  };

  # Filesystems
  boot.initrd.luks.devices = [
    {
      name = "systempv";
      device = "/dev/disk/by-uuid/64d7cea3-9308-4198-919e-f980f499b7b1";
      preLVM = true;
    }
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ]; # SSD
  };
  fileSystems."/home/" = {
    device = "/dev/disk/by-label/user";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ]; # SSD
  };

  # System Configuration
  system.stateVersion = "17.09";
  system.autoUpgrade.enable = true;
  time.timeZone = "America/Los_Angeles";
  services.nixosManual.showManual = true;

  # Boot Configuration
  ## Not GRUB!
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
  # User Configuration
  users.extraUsers.remingtonc = {
    isNormalUser = true;
    uid = 1000;
    gid = 1000;
    group = "remingtonc";
    extraGroups = [ "wheel" "disk" "video" "networkmanager" "systemd-journal" "audio" "docker" ];
    createHome = true;
    shell = "/run/current-system/sw/bin/fish";
  };

  # Networking Configuration
  networking = {
    hostName = "Odin";
    networkmanager.enable = true;
    ## Connectivity
    enableIPv6 = false;
    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    ## Firewall
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 20 21 22 25 ];
      # allowedUDPPorts = [ ... ];
    };
    ## Virtualized Networking
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "wlp1s0";
    };
  };
  
  # Manageability Configuration
  services.openssh.enable = true;
  
  # Services Configuration
  ## CUPS
  services.printing.enable = true;
  ## X11
  services.xserver = {
    enable = true;
    layout = "us";
    ### Trackpad
    synaptics = {
      enable = true;
      twoFingerScroll = true;
    };
    ### DE
    displayManager = {
      sddm.enable = true;
      plasma5.enable = true;
    };
  };
  ## System
  services.acpid.enable = true;

  # Packages
  ## No idea what I'm doing with these settings
  programs = {
    fish.enable = true;
    mosh.enable = true;
    tmux.enable = true;
    ssh.enable = true;
    nano.enable = true;
    vim.enable = true;
    man.enable = true;
  };
  ## Actually request packages now
  nixpkgs.config.allowUnfree = true; # Required for Spotify :)
  environment.systemPackages = with pkgs; [
    docker
    spotify
    vlc
    firefox
    vscode
    alacritty
    bash
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
