{ ... }:

{
  home-manager.users.jafed =
    { inputs, ... }:
    {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      programs.caelestia = {
        enable = true;
        systemd = {
          enable = true; # if you prefer starting from your compositor
          target = "graphical-session.target";
          environment = [ ];
        };
        settings = {
          bar.status = {
            showBattery = false;
          };
          paths.wallpaperDir = "~/.build/themes/wallpapers";
        };
        cli = {
          enable = true; # Also add caelestia-cli to path
          settings = {
            theme.enableGtk = false;
          };
        };
      };
    };

}
