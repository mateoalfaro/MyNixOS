{ pkgs, ... }:

{
  programs.singularity-desktop = {
    enable = true;
    greeter = {
      enable = true;
      background = ../themes/wallpapers/image.png;
    };
  };

  # As of 25.11
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    snapshot
    gnome-tour
    gnome-contacts
    gnome-maps
    gnome-user-docs
  ];
}
