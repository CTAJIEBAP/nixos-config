# This is balsoft's configuration file.
#
# https://github.com/balsoft/nixos-config
#
# This is main nixos configuration
# To use this configuration:
#   1. Add your own secret.nix to this folder
#   2. Replace /etc/nixos/configuration.nix with the following:
#      import /path/to/this/nixos-config "Vendor-Type"
#   3. Log in to application and services where neccesary


device: # This is the device we're on now
{ config, pkgs, lib, ... }: 
{
  # ========================== HARDWARE =====================================
  imports =
  [
    /etc/nixos/hardware-configuration.nix
    ./imports/home-manager/nixos
    ./modules
  ];
  inherit device;
  nix.nixPath = let PWD = builtins.getEnv "PWD"; in
  [
  "nixpkgs=${./imports/nixpkgs}"
  "home-manager=${./imports/home-manager}"
  "nixos-config=/etc/nixos/configuration.nix"
  ];
  system.stateVersion = "18.03";
}
