{ ... }:

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

    # Desktop Environment
    ./modules/gnome.nix

    # Extras
    ./config/coding.nix
    ./config/gaming.nix
  ];
}
