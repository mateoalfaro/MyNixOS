{ pkgs, ... }:

{
  # Time & Locale
  time.timeZone = "America/Costa_Rica";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  # Keyboard Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # System State Version
  system.stateVersion = "25.11";

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # Services (requires a configured XDG Portal)
  services.flatpak.enable = true;

  # SystemWide Packages
  environment.systemPackages = with pkgs; [
    git
  ];
}
