{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    ryubing
    zed-editor
    sbctl
    bazaar
    mathematica
    vlc
    nixd
    resources
    stremio-linux-shell
    opencode
    bibata-cursors
    papirus-icon-theme
  ];
}
