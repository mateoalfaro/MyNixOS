{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bazaar
    bibata-cursors
    discord
    #    mathematica
    onlyoffice-desktopeditors
    papirus-icon-theme
    resources
    ryubing
    sbctl
    stremio-linux-shell
    vlc
    zed-editor
  ];
}
