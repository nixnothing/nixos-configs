{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    /home/nix/Code/nixos-configs/nix-desktop.nix
    /etc/nixos/hardware-configuration.nix
  ];
}
