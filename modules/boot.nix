{ lib, ... }:

{
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;

    autoGenerateKeys.enable = true;
    pkiBundle = "/var/lib/sbctl";

    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };
}
