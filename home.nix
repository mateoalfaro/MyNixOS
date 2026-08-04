{ ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.jafed = { ... }: {
      home = {
        username = "jafed";
        homeDirectory = "/home/jafed";
        stateVersion = "26.11";
      };

      programs.home-manager.enable = true;
    };
  };
}
