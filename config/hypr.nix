{ pkgs, ... }:

{
  # NIXOS OPTIONS
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  services.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    nautilus
  ];
  # HOME MANAGER
  home-manager.users.jafed =
    { ... }:
    {
      imports = [ ];

      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Modern-Classic"; # The internal theme name (inside index.theme)
        package = pkgs.bibata-cursors; # The Nix package
        size = 24;
      };

      gtk = {
        enable = true;

        # Icon Theme (Folders, App Icons)
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        # Window/Control Theme (The dark grey UI background)
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };

        # Force Dark Mode in GTK3 Apps
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        # Force Dark Mode in GTK4 Apps
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      # 2. Modern "Libadwaita" apps (like Nautilus/Gnome Calculator) need this dconf setting
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      # 3. Make Qt apps (like Dolphin, KDE apps) look like GTK apps
      qt = {
        enable = true;
        platformTheme.name = "gtk";
        style.name = "adwaita-dark";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        settings = {
          # DISPLAYS
          monitor = [
            "DP-2, 2560x1440@180, 0x0, 1, vrr, 1"
            "HDMI-A-1, 3840x2160@60, 2560x0, 1.5"
          ];

          env = [
            "HYPRCURSOR_THEME,Bibata-Modern-Classic"
            "HYPRCURSOR_SIZE,24"
            "XCURSOR_THEME,Bibata-Modern-Classic"
            "XCURSOR_SIZE,24"
          ];

          # BINDS
          bind = [
            "SUPER, W, exec, uwsm app -- google-chrome-stable"
            "SUPER, T, exec, uwsm app -- ghostty"

            "ALT, Space, global, caelestia:launcher"
            "SUPER, Q, killactive"
            "SUPER, F, fullscreen"

            # Workspace switching
            "SUPER, M, exec, caelestia toggle music"
            "SUPER, N, exec, caelestia toggle communication"

            # Utils
            ", Print, global, caelestia:screenshotFreeze"
            "SUPER, Print, exec, caelestia screenshot"
          ];
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];

          # Gaps and general appearance
          general = {
            layout = "dwindle";
            gaps_workspaces = 20;
            gaps_in = 10;
            gaps_out = 18;
            border_size = 3;

            "col.active_border" = "0xffBEDC74";
            "col.inactive_border" = "0xff3E4B35";
          };

          dwindle = {
            preserve_split = true;
            smart_split = false;
            smart_resizing = true;
          };
          # Decorations
          decoration = {
            rounding = "10";

            active_opacity = 0.95;
            inactive_opacity = 0.95;
            fullscreen_opacity = 1.0;

            blur = {
              enabled = true;
              xray = false;
              special = false;
              ignore_opacity = true;
              new_optimizations = true;
              popups = true;
              input_methods = true;
              size = 8;
              passes = 2;
            };
            shadow = {
              enabled = true;
              range = 20;
              render_power = 3;
              color = "0x990A1208";
            };
          };
        };
      };
    };

}
