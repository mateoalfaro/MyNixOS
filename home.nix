{ pkgs, ... }:
{
  home = {
    username = "jafed";
    homeDirectory = "/home/jafed";
    packages = with pkgs; [
      google-chrome
      ghostty
      vesktop
      zed-editor
      cider-2
      bazaar
    ];
    stateVersion = "25.11";
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;

}
