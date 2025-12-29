{ ... }:

{
  # NIXOS OPTIONS
  programs.nix-ld.enable = true;

  # HOME MANAGER
  home-manager.users.jafed =
    { pkgs, ... }:
    {
      imports = [ ];

      home.packages = with pkgs; [
        nixd
        nil
      ];

      programs.zed-editor = {
        enable = true;
        extensions = [ "nix" ];
        userSettings = {
          theme = {
            mode = "dark";
            dark = "One Dark";
            light = "One Light";
          };
          hour_format = "hour12";
          vim_mode = false;
        };
      };
    };
}
