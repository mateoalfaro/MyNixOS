{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    eden
    zed-editor
    sbctl
    bazaar
    mathematica
    vlc
    nixd
    inputs.singularity-desktop.packages.${pkgs.system}.default
  ];
}
