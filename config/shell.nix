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

          launcher = {
            actionPrefix = "/";
            actions = [
              {
                name = "Rebuild";
                icon = "build"; # Uses Material Icon "build" or try "system_update"
                description = "Sudo NixOS Rebuild Switch";
                # Use the command below. If you use flakes, change to:
                # ["sudo" "nixos-rebuild" "switch" "--flake" "/path/to/flake"]
                command = [
                  "sudo"
                  "nixos-rebuild"
                  "switch"
                  "--flake"
                  "/home/jafed/.build"
                ];
                enabled = true;
              }
              {
                name = "Calculator";
                icon = "calculate";
                description = "Do simple math equations (powered by Qalc)";
                command = [
                  "autocomplete"
                  "calc"
                ];
                enabled = true;
                dangerous = false;
              }
              {
                name = "Wallpaper";
                icon = "image";
                description = "Change the current wallpaper";
                command = [
                  "autocomplete"
                  "wallpaper"
                ];
                enabled = true;
                dangerous = false;
              }
              {
                name = "Light";
                icon = "light_mode";
                description = "Change the scheme to light mode";
                command = [
                  "setMode"
                  "light"
                ];
                enabled = true;
                dangerous = false;
              }
              {
                name = "Dark";
                icon = "dark_mode";
                description = "Change the scheme to dark mode";
                command = [
                  "setMode"
                  "dark"
                ];
                enabled = true;
                dangerous = false;
              }
              {
                name = "Shutdown";
                icon = "power_settings_new";
                description = "Shutdown the system";
                command = [
                  "systemctl"
                  "poweroff"
                ];
                enabled = true;
                dangerous = true;
              }
              {
                name = "Reboot";
                icon = "cached";
                description = "Reboot the system";
                command = [
                  "systemctl"
                  "reboot"
                ];
                enabled = true;
                dangerous = true;
              }
            ];
          };
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
