{ pkgs, ... }:
{
  home = {
    username = "jafed";
    homeDirectory = "/home/jafed";
    packages = with pkgs; [
      google-chrome
      vesktop
      zed-editor
      sbctl
      bazaar
      vlc
    ];
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

}
