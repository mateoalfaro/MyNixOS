{ ... }:

{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # Core system
    ./modules/boot.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/system.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./home.nix

    # Desktop Environment
    ./modules/gnome.nix

    # Extras
    ./config/gaming.nix
    ./config/code.nix
  ];
}
