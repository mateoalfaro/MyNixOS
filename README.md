# NixOS desktop configuration

Personal NixOS flake for the `nixos` host, with Home Manager and a GNOME-based
Singularity desktop.

## Layout

```text
.
├── config/                    # Optional workstation profiles
│   ├── code.nix               # Development tools and Codex integration
│   └── gaming.nix             # Steam, GameMode, and Gamescope
├── desktop/                   # Persisted desktop application data
├── modules/                   # Core NixOS modules
│   ├── boot.nix
│   ├── gnome.nix
│   ├── hardware.nix
│   ├── networking.nix
│   ├── packages.nix
│   ├── system.nix
│   └── users.nix
├── themes/                    # Wallpapers and other visual assets
├── flake.nix                  # Inputs and host outputs
├── hardware-configuration.nix # Generated machine-specific hardware config
├── home.nix                   # Home Manager base configuration
└── imports.nix                # Module import manifest
```

`torbox.yml` is a TorBox indexer definition. The files under
`desktop/zen-sessions-backup/` are persisted Zen Browser session backups and
should not be edited as configuration.

## Apply

Rebuild the configured host from this directory:

```sh
nh os switch
```

Equivalent NixOS command:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

## Validate

Evaluate the complete system without activating it:

```sh
nix build
```

Format all Nix files with the flake's pinned formatter:

```sh
nix fmt -- flake.nix home.nix imports.nix config/*.nix modules/*.nix
```

Update pinned inputs explicitly when desired:

```sh
nix flake update
```

The local `singularity-desktop` input expects its flake at
`/home/jafed/singularity-flake`.
