{ config, pkgs, ... }:

{
  imports = [
    # Hardware Configuration
    ./hardware-configuration.nix

    # Software Configuration
    ./modules/boot.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/system.nix
    ./modules/users.nix

    # Extras
    ./config/gaming.nix
    ./config/hypr.nix
    ./config/launcher.nix
  ];
}
