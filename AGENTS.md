# Repository Instructions

This repository defines the NixOS desktop configuration for the `nixos` host.

## Validation

- Do not run `nix build` in this repository. Building the complete desktop system takes too long.
- Do not run commands that implicitly build the full NixOS system unless the user explicitly requests it.
- Format Nix changes with `nix fmt -- flake.nix home.nix imports.nix config/*.nix modules/*.nix`.
- Prefer lightweight evaluation or syntax checks when validation is needed.

## Applying Changes

- Do not activate or switch the system unless the user explicitly requests it.
- The user applies this configuration with `nh os switch`.

## Structure

- Keep core NixOS modules under `modules/`.
- Keep optional or feature-specific configuration under `config/`.
- Keep Home Manager's base configuration in `home.nix`.
- Keep Caelestia and Hyprland settings together in `config/caelestia.nix`.
