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
          bar = {
            status = {
              showBattery = false;
              showAudio = true;
              showMicrophone = false;
            };
            scrollActions = {
              volume = true;
              brightness = false;
            };
          };

          services = {
            smartScheme = true;
          };

          osd = {
            enableBrightness = false; # Disables the brightness slider popup
          };
          paths = {
            wallpaperDir = "~/.build/themes/wallpapers";
            sessionGif = "";
          };
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
