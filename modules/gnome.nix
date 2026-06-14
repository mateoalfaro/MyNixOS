{ inputs, pkgs, ... }:

{
  services.displayManager.sessionPackages = [
      inputs.singularity-desktop.packages.${pkgs.system}.default
    ];
  # As of 25.11
  services.displayManager.gdm.enable = true;
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
