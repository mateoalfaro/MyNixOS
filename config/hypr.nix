{ ... }:

{
  # NIXOS OPTIONS
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.sddm.wayland.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # HOME MANAGER
  home-manager.users.jafed =
    { ... }:
    {
      imports = [ ];

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

          # BINDS
          bind = [
            "SUPER, T, exec, ghostty"

            "ALT, Space, exec, vicinae toggle"
            "SUPER, Q, killactive"
            "SUPER, F, fullscreen"
          ];
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
        };
      };
    };

}
