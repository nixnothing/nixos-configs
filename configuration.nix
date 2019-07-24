# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
   #The next few liness enable WideVine drm support (fixes netflix on chromium)
   vinefixPkgs = import (builtins.fetchTarball 
   https://github.com/nixos/nixpkgs/archive/e0c31611e88865cd8c0e41ef3b4fefa34b258ae8.tar.gz) 
   {config = config.nixpkgs.config; }; 
 
   pkgs2 = import (builtins.fetchTarball 
   https://github.com/nixos/nixpkgs/archive/bc94dcf5002.tar.gz) 
   {config.allowUnfree = true; };

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    nixpkgs.config.allowUnfree= true;
    programs.screen.screenrc ='' 
      startup_message off
      hardstatus alwayslastline
      shelltitle 'bash'
      hardstatus string '%{gk}[%{wk}%?%-Lw%?%{=b kR}(%{W}%n*%f %t%?(%u)%?%{=b kR})%{= w}%?%+Lw%?%? %{g}][%{d}%l%{g}][ %{= w}%Y/%m/%d %0C:%s%a%{g} ]%{W}'
    '';
    users.users = { 
      nix = { 
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        uid = 1000;
        initialPassword = "foobar";
      };  
    };  
networking.interfaces.enp0s25.ipv4.addresses = [
  { address = "192.168.1.101"; prefixLength = 24; }
];
networking.defaultGateway = {
	address="192.168.1.1";
	interface="enp0s25";
};
networking.nameservers = [ "192.168.1.1" ];
fileSystems = {
  "/nas" = {
    fsType = "nfs";
    device = "192.168.1.10:/nas";
    options = [ "nofail" "_netdev" "soft" ];
  };
  "/private-nas" = {
    fsType = "nfs";
    device = "192.168.1.10:/home/nix/nasraid/private";
    options = [ "nofail" "_netdev" "soft" ];
  };
};
#    nixpkgs.config.chromium.enableWideVine = true;
    virtualisation.virtualbox.host.enable = true;

    services.zfs.autoSnapshot.enable = true;
    services.xserver= {
      enable= true;
      desktopManager.xfce.enable = true;
    };  

    environment.systemPackages = with pkgs;
      [midori firefox chromium keepassxc discord steam syncplay deluge ranger handbrake
	mpv vlc gimp pavucontrol python python3 irssi lynx screen libreoffice gparted youtube-dl mkvtoolnix 
	atom smartmontools lame htop iftop dropbox vnstat unrar unzip gnome3.file-roller openssl zip wget
	screen usbutils xscreensaver wireshark-qt p7zip ncdu plex-media-player gist xfce.xfce4-pulseaudio-plugin
	kodiPlain gdb file wineWowPackages.full xlibs.xev compton (import /home/nix/ts-56.nix) 
	(pkgs.callPackage /home/nix/NixFixes/vsfix.nix {}) vscode rhythmbox git vinefixPkgs.chromium postgresql_11
	woeusb k3b];  

	systemd.coredump.enable = true;

    hardware = { 
      pulseaudio = { 
        enable = true;
        support32Bit = true;
      };  

      opengl = { 
        driSupport32Bit = true;
      };  
    };  

  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;

#zfs filesystem stuff?
    networking.hostId = "1a41bc25";

#boot stuff
  boot = {
    supportedFilesystems = [ "ntfs" ];
    loader.grub = {
      device = "/dev/sda";
      enable = true;
	version = 2;
	 extraEntries = ''
        menuentry "Windows 10" {
          insmod part_msdos
          insmod chain
          set root="hd1,msdos1"
          chainloader +1
        }
      '';
    };
  };

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # nix - fixes windows dual-boot messing w/ system clock
  time = {
     hardwareClockInLocalTime = true;
     timeZone = "America/Chicago";
     };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
