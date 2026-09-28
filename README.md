# NixOS desktop configuration

Personal NixOS flake for the `nixos` host, with Home Manager, a GNOME-based
Singularity desktop, and a Hyprland session running adwshell, a GNOME-looking
shell built with GTK4 and libadwaita. Pick the session at the GDM login.

## Layout

```text
.
├── config/                    # Optional workstation profiles
│   ├── code.nix               # Development tools and Codex integration
│   ├── gaming.nix             # Steam, GameMode, and Gamescope
│   └── hyprland.nix           # Hyprland session, keybinds, lock screen, adwshell
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

## Hyprland session

adwshell ([its own flake](/home/jafed/devwork/adwshell), input `adwshell`)
provides the top bar, a search launcher, quick settings, the
calendar/notification menu, notification banners, a volume OSD and the
wallpaper. It follows GNOME's settings (wallpaper, dark style, accent colour,
clock format, dash favourites), and its launcher uses GNOME's search providers.
Personal CSS tweaks can go in `~/.config/adwshell/style.css`.

The top bar is transparent and switches between light and dark text depending
on the wallpaper under it; pass `--solid-bar` (in `config/hyprland.nix`) for a
black bar. Quick Settings follows the GNOME Shell design proposal: pill sliders,
split toggles, media controls, background (tray) apps, and a pencil button that
opens an editor to show or hide toggles. The chosen toggles are saved in
`~/.local/state/adwshell/quick-settings.json`.

| Keys | Action |
| --- | --- |
| Super (tap), Super+A, Alt+Space | Search launcher |
| Super+S / Super+V | Quick settings / calendar and notifications |
| Super+T / Super+E / Super+W | Console / Files / Chrome |
| Super+Q, Alt+F4 | Close window |
| Super+F / Super+Shift+F | Fullscreen / toggle floating |
| Super+arrows / Super+Shift+arrows | Focus / swap windows |
| Super+1…0 / Super+Shift+1…0 | Switch / move to workspace |
| Super+Page Up/Down, Super+scroll | Previous / next workspace |
| Super+L | Lock |
| Print / Shift+Print | Screenshot area / screen |

In the launcher, `>` runs a command, Up/Down/Tab move the selection and Enter
activates it.

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
