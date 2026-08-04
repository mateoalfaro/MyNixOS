{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bazaar
    bibata-cursors
    discord
    ghostty
    mathematica
    onlyoffice-desktopeditors
    papirus-icon-theme
    resources
    ryubing
    sbctl
    stremio-linux-shell
    vicinae
    vlc
    zed-editor
  ];
}
