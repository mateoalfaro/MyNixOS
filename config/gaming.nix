{ pkgs, ... }:

{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;

    gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = false;
    };
  };

}
