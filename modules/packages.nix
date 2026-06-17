{ inputs, pkgs, ... }:

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
    inputs.singularity-desktop.packages.${pkgs.system}.default
  ];
}
