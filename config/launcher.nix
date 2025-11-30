{ config, pkgs, ... }:

{
  home-manager.users.jafed = { pkgs, inputs, ... }: {
    imports = [ inputs.vicinae.homeManagerModules.default ];

    services.vicinae = {
        enable = true; # default: false
        autoStart = true; # default: true
        # package = # specify package to use here. Can be omitted.
    };
  };

}
