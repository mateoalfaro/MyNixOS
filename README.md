# dotfiles
A NixOS template for a flakes + home-manager based config

## structure
```
/etc/nixos/
 ├── flake.nix                  # Flake definition
 ├── home.nix                   # Home-manager configuration
 ├── imports.nix                # Hub for all imports
 ├── hardware-configuration.nix # (must be manually imported)
 └── modules/                   # home to the rest of the config
    ├── boot.nix
    ├── hardware.nix
    ├── networking.nix
    ├── system.nix
    └── users.nix
 └── config/                    # Personal stuff 
```
