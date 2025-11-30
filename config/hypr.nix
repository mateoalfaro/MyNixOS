{ config, pkgs, inputs, ... }:

{
  # NIXOS OPTIONS
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # HOME MANAGER
  home-manager.users.jafed = { pkgs, inputs, ... }: {
    imports = [ ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;

      settings = {
        
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

