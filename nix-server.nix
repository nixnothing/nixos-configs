{ config, pkgs, ... }:
let
in {
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
        #initialPassword = "foobar";
      };
    };
    environment.systemPackages = with pkgs;
      [ranger python python3 irssi lynx screen youtube-dl mkvtoolnix
        smartmontools lame htop iftop vnstat unrar unzip openssl zip wget
        usbutils p7zip ncdu gist gdb file git postgresql_11 woeusb];

        systemd.coredump.enable = true;

    time = {
      timeZone = "America/Chicago";
    };
}

