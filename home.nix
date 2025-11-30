{ config, pkgs, ... }:
{
  home = {
    username = "jafed";
    homeDirectory = "/home/jafed";
    packages = with pkgs; [
      google-chrome
      ghostty
      vesktop
      zed-editor
    ];
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

}
