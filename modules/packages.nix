{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    appimage-run
    bazaar
    bibata-cursors
    discord
    onlyoffice-desktopeditors
    papirus-icon-theme
    resources
    ryubing
    sbctl
    stremio-linux-shell
    google-chrome
    vlc
    zed-editor
    python3
    python3Packages.pillow
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
